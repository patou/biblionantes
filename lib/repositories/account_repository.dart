import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateException implements Exception {
  final _message;
  final _prefix = 'Error during HTTP call: ';

  AuthenticateException([this._message]);

  String toString() {
    return "$_prefix$_message";
  }
}

@immutable
class LibraryCardRepository {
  static String ACCOUNTS_LIST_SHARED_PREF = "bionantes.accounts";
  final Dio client;
  final _controller = StreamController<List<LibraryCard>>();

  LibraryCardRepository({required this.client});
  
  Future<void>  loadLibraryCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(ACCOUNTS_LIST_SHARED_PREF)) {
      accounts = prefs.getStringList(ACCOUNTS_LIST_SHARED_PREF)!.map((str) =>
          LibraryCard.fromSharedPref(str)).toList();
    }
    else {
      accounts = [];
    }
    _controller.add(accounts);
  }

  Future<void> saveLibraryCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saved = accounts.map<String>((e) => e.toSharedPref()).toList(growable: false);
    print(saved.join(","));
    prefs.setStringList(ACCOUNTS_LIST_SHARED_PREF, saved);
  }

  List<LibraryCard> accounts = [];

  Map<String, String> tokens = Map();

  Stream<List<LibraryCard>> getLibraryCards() async* {
    await loadLibraryCards();
    yield* this._controller.stream;
  }

  Future<AuthentInfo> addLibraryCards(String name, String login, String pass) async {
    AuthentInfo authentInfo = await refreshAccountToken(login, pass);
    this.accounts.add(LibraryCard(login: login, password: pass, userId: authentInfo.userId, name: name));
    await saveLibraryCards();
    _controller.add(accounts);
    return authentInfo;
  }

  Future<AuthentInfo> refreshAccountToken(String login, String pass) async {
    final response =
        await client.post('authenticate',
            data: {"username": login, "password": pass, "birthdate": pass,"locale":"fr"}
        );
    
    if (response.statusCode != 200) {
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    AuthentInfo authentInfo = AuthentInfo.fromJson(response.data);
    tokens[authentInfo.login] = authentInfo.token;
    return authentInfo;
  }

  Future<SummeryAccount> loadSummaryAccount(LibraryCard libraryCard) async {
    if (!tokens.containsKey(libraryCard.login) || tokens[libraryCard.login]!.isNotEmpty) {
      await refreshAccountToken(libraryCard.login, libraryCard.password);
    }
    final response =
    await client.get('accountSummary',
        queryParameters: {
          'locale': 'fr'
        },
        options: Options(
          headers:{
            'Authorization': 'Bearer ${tokens[libraryCard.login]}'
          })
    );
    if (response.statusCode != 200) {
      tokens.remove(libraryCard.userId);
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    return SummeryAccount.fromJson(response.data);
  }

  Future<void> removeLibraryCard(LibraryCard libraryCard) async {
    this.accounts.remove(libraryCard);
    await saveLibraryCards();
    _controller.add(accounts);
  }

  Future<List<LoansBook>> loadLoansList() async {
    var results = await Future.wait(accounts.map((account) { return this.loadLoansListByAccount(account); }));
    return results.expand((element) => element).toList();
  }

  Future<List<LoansBook>> loadLoansListByAccount(LibraryCard account) async {
    print("load ${account.name} ${account.login}");
    if (!tokens.containsKey(account.login) || tokens[account.login]!.isNotEmpty) {
      print("refresh token ${account.login}");
      await refreshAccountToken(account.login, account.password);
    }
    final response =
        await client.get('accountPage',
        queryParameters: {
          'locale': 'fr',
          'type': 'loans',
          'pageNo': '1',
          'pageSize': '15'
        },
        options: Options(
            headers:{
              'Authorization': 'Bearer ${tokens[account.login]}'
            })
    );
    if (response.statusCode != 200) {
      tokens.remove(account.userId);
      print(response);
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    var list = response.data['items'].map<LoansBook>((json) => LoansBook.fromJson(json, account.name)).toList();
    return list;
  }

  void dispose() => _controller.close();
}