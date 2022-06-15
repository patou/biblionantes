import 'package:biblionantes/models/summery_account.dart';
import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/models/reservation.dart';
import 'package:biblionantes/models/reservationsbook.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateException implements Exception {
  final dynamic _message;
  final _prefix = 'Error during HTTP call: ';

  AuthenticateException([this._message]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class LibraryCardRepository {
  static const String accountsListSharedPref = "biblionantes.accounts";
  final Dio client;
  final _controller = StreamController<List<LibraryCard>>();

  LibraryCardRepository({required this.client});

  Future<void> loadLibraryCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(accountsListSharedPref)) {
      accounts = prefs
          .getStringList(accountsListSharedPref)!
          .map((str) => LibraryCard.fromSharedPref(str))
          .toList();
    } else {
      accounts = [];
    }
    _controller.add(accounts);
  }

  Future<void> saveLibraryCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saved =
        accounts.map<String>((e) => e.toSharedPref()).toList(growable: false);
    print(saved.join(","));
    prefs.setStringList(accountsListSharedPref, saved);
  }

  List<LibraryCard> accounts = [];

  Map<String, String> tokens = {};
  String? lastToken;

  Stream<List<LibraryCard>> getLibraryCards() async* {
    await loadLibraryCards();
    yield* _controller.stream;
  }

  Future<AuthentInfo> addLibraryCards(
      String name, String login, String pass) async {
    AuthentInfo authentInfo = await refreshAccountToken(login, pass);
    accounts.add(LibraryCard(
        login: login, password: pass, userId: authentInfo.userId, name: name));
    await saveLibraryCards();
    _controller.add(accounts);
    return authentInfo;
  }

  Future<AuthentInfo> refreshAccountToken(String login, String pass) async {
    final response = await client.post('authenticate', data: {
      "username": login,
      "password": pass,
      "birthdate": pass,
      "locale": "fr"
    });

    if (response.statusCode != 200) {
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    AuthentInfo authentInfo = AuthentInfo.fromJson(response.data);
    lastToken = authentInfo.token;
    tokens[authentInfo.login] = authentInfo.token;
    return authentInfo;
  }

  Future<void> refreshTokens() async {
    if (lastToken == null) {
      await Future.any(accounts.map((accounts) =>
          refreshAccountToken(accounts.login, accounts.password)));
    }
  }

  Future<SummeryAccount> loadSummaryAccount(LibraryCard libraryCard) async {
    if (!tokens.containsKey(libraryCard.login) ||
        tokens[libraryCard.login]!.isNotEmpty) {
      await refreshAccountToken(libraryCard.login, libraryCard.password);
    }
    final response = await client.get('accountSummary',
        queryParameters: {'locale': 'fr'},
        options: Options(
            headers: {'Authorization': 'Bearer ${tokens[libraryCard.login]}'}));
    if (response.statusCode != 200) {
      tokens.remove(libraryCard.userId);
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    return SummeryAccount.fromJson(response.data);
  }

  Future<void> removeLibraryCard(LibraryCard libraryCard) async {
    accounts.remove(libraryCard);
    await saveLibraryCards();
    _controller.add(accounts);
  }

  Future<List<LoansBook>> loadLoansList() async {
    var results = await Future.wait(accounts.map((account) {
      return loadLoansListByAccount(account);
    }));
    return results.expand((element) => element).toList();
  }

  Future<List<LoansBook>> loadLoansListByAccount(LibraryCard account) async {
    print("load ${account.name} ${account.login}");
    if (!tokens.containsKey(account.login) ||
        tokens[account.login]!.isNotEmpty) {
      print("refresh token ${account.login}");
      await refreshAccountToken(account.login, account.password);
    }
    final response = await client.get('accountPage',
        queryParameters: {
          'locale': 'fr',
          'type': 'loans',
          'pageNo': '1',
          'pageSize': '15'
        },
        options: Options(
            headers: {'Authorization': 'Bearer ${tokens[account.login]}'}));
    if (response.statusCode != 200) {
      tokens.remove(account.userId);
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    var list = response.data['items']
        .map<LoansBook>(
            (json) => LoansBook.fromJson(json, account.name, account.login))
        .toList();
    return list;
  }

  Future<List<ReservationsBook>> loadReservationsList() async {
    var results = await Future.wait(accounts.map((account) {
      return loadReservationsListByAccount(account);
    }));
    return results.expand((element) => element).toList();
  }

  Future<List<ReservationsBook>> loadReservationsListByAccount(
      LibraryCard account) async {
    print("load reservations ${account.name} ${account.login}");
    if (!tokens.containsKey(account.login) ||
        tokens[account.login]!.isNotEmpty) {
      print("refresh token ${account.login}");
      await refreshAccountToken(account.login, account.password);
    }
    final response = await client.get('accountPage',
        queryParameters: {
          'locale': 'fr',
          'type': 'reservations',
          'pageNo': '1',
          'pageSize': '15'
        },
        options: Options(
            headers: {'Authorization': 'Bearer ${tokens[account.login]}'}));
    if (response.statusCode != 200) {
      tokens.remove(account.userId);
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    var list = response.data['items']
        .map<ReservationsBook>((json) =>
            ReservationsBook.fromJson(json, account.name, account.login))
        .toList();
    return list;
  }

  Future<List<LoansBook>> resolveBook(List<LoansBook> books) async {
    if (books.isEmpty) {
      return [];
    }
    var data = await resolveBookBySeqNos(books.map((e) => e.seqNo));
    if (data == null) {
      return books;
    }
    return books.map((loadBook) {
      Book? book = data[loadBook.id];
      return book != null ? loadBook.copyFromBook(book) : loadBook;
    }).toList();
  }

  Future<List<ReservationsBook>> resolveReservableBook(
      List<ReservationsBook> books) async {
    if (books.isEmpty) {
      return [];
    }
    var data = await resolveBookBySeqNos(books.map((e) => e.seqNo));
    if (data == null) {
      return books;
    }
    return books.map((loadBook) {
      Book? book = data[loadBook.id];
      return book != null ? loadBook.copyFromBook(book) : loadBook;
    }).toList();
  }

  Future<Map<String, Book>?> resolveBookBySeqNos(Iterable<String> ids) async {
    await refreshTokens();
    final response = await client.post('resolveBySeqNo',
        data: {
          "locale": "fr",
          "ids": ids.join(","),
        },
        options:
            Options(contentType: Headers.formUrlEncodedContentType, headers: {
          // Le token attend le token d'authentification plus un autre ID, qui ne semble pas utilisé.
          'X-InMedia-Authorization': 'Bearer $lastToken 3'
        }));
    if (response.statusCode != 200 || response.data['resultSet'] == null) {
      print("error");
      return null;
    }
    Map<String, Book> data = Map.fromIterable(
        response.data['resultSet']
            .map<Book>((json) => Book.fromJson(json))
            .toList(),
        key: (book) => book.id);
    return data;
  }

  void dispose() => _controller.close();

  Future<bool> renewBook(String account, String documentNumber) async {
    final response = await client.get('renewLoan',
        queryParameters: {
          'documentId': documentNumber,
        },
        options:
            Options(headers: {'Authorization': 'Bearer ${tokens[account]}'}));
    if (response.statusCode != 200 || response.data['extended'] == null) {
      print("error renewBook");
      return false;
    }
    return response.data['extended'] as bool;
  }

  Future<bool> cancelReservationBook(
      String account, String seqNo, String branchCode, String omnidexId) async {
    final response = await client.get('cancelReservation',
        queryParameters: {
          'seqNo': seqNo,
          'pickupBranch': branchCode,
          'omnidexId': omnidexId,
        },
        options:
            Options(headers: {'Authorization': 'Bearer ${tokens[account]}'}));
    if (response.statusCode != 200) {
      print("error cancelReservationBook");
      return false;
    }
    return response.data as bool;
  }

  Future<List<ReservationChoices>> reservationChoices(String bookId) async {
    await refreshTokens();
    final response = await client.get('reservationChoices',
        queryParameters: {
          'id': bookId,
          'locale': 'fr',
        },
        options: Options(headers: {
          'X-InMedia-Authorization':
              'Bearer $lastToken 3' // The header is not the same and not work if there are not 2 tokens with defined value for the second one
        }));
    if (response.statusCode != 200) {
      print("error");
      return Future.error(AuthenticateException(
          'error occurred when get reservation choices: ${response.statusCode}'));
    }
    return response.data['branchList']
        .map<ReservationChoices>((json) => ReservationChoices.fromJson(json))
        .toList();
  }

  Future<bool> reserveBook(
      String account, String location, String documentId) async {
    final response = await client.get('makeReservation',
        queryParameters: {
          'id': documentId,
          'branch': location,
          'locale': 'fr',
        },
        options:
            Options(headers: {'Authorization': 'Bearer ${tokens[account]}'}));
    if (response.statusCode != 200 || response.data['errorReponse'] != null) {
      print("error ${response.data['error']}");
      return Future.error(response.data['error']);
    }
    return response.data['errorCode'] == "SUCCESS";
  }
}
