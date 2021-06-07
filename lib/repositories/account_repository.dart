import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

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
class AccountRepository {
  static String ACCOUNTS_LIST_SHARED_PREF = "bionantes.accounts";
  final Dio client;

  AccountRepository({required this.client});
  
  Future<void> loadAccounts() async {
    if (accounts == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(ACCOUNTS_LIST_SHARED_PREF)) {
        accounts = prefs.getStringList(ACCOUNTS_LIST_SHARED_PREF)!.map((str) =>
            Account.fromSharedPref(str)).toList();
      }
      else {
        accounts = [];
      }
    }
  }

  Future<void> saveAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saved = accounts.map<String>((e) => e.toSharedPref()).toList(growable: false);
    print(saved.join(","));
    prefs.setStringList(ACCOUNTS_LIST_SHARED_PREF, saved);
  }

  List<Account> accounts = [];

  Map<String, String> tokens = Map();

  Future<List<Account>> getAccounts() async {
    await loadAccounts();
    return this.accounts;
  }

  Future<AuthentInfo> addAccount(String name, String login, String pass) async {
    AuthentInfo authentInfo = await refreshAccountToken(login, pass);
    this.accounts.add(Account(login: login, password: pass, userId: authentInfo.userId, name: name));
    await saveAccounts();
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

  Future<SummeryAccount> loadSummaryAccount(Account account) async {
    print("load ${account.name} ${account.login}");
    if (!tokens.containsKey(account.login) || tokens[account.login]!.isNotEmpty) {
      print("refresh token ${account.login}");
      await refreshAccountToken(account.login, account.password);
    }
    final response =
    await client.get('accountSummary',
        queryParameters: {
          'locale': 'fr'
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
    print(response.data);
    return SummeryAccount.fromJson(response.data);
  }

  Future<void> deleteAccount(Account account) async {
    this.accounts.remove(account);
    await saveAccounts();
  }

  Future<List<LoansBook>> loadLoansList() async {
    var results = await Future.wait(accounts.map((account) { return this.loadLoansListByAccount(account); }));
    return results.expand((element) => element).toList();
  }

  Future<List<LoansBook>> loadLoansListByAccount(Account account) async {
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
}