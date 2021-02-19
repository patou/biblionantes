import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

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
  final Dio client;

  AccountRepository({@required this.client}) : assert(client != null);

  List<Account> accounts = List();

  Map<String, String> tokens = Map();

  List<Account> getAccounts() {
    return this.accounts;
  }

  Future<AuthentInfo> addAccount(String name, String login, String pass) async {
    AuthentInfo authentInfo = await refreshAccountToken(login, pass);
    this.accounts.add(Account(login: login, password: pass, userId: authentInfo.userId, name: name));
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
    if (!tokens.containsKey(account.login) || !tokens[account.login].isEmpty) {
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
}