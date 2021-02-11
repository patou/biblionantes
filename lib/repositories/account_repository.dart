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
    final response =
        await client.post('authenticate',
            data: {"username": login, "password": pass, "birthdate": pass,"locale":"fr"}
        );

    if (response.statusCode != 200) {
      return Future.error(AuthenticateException(
          'error occurred when authenticate: ${response.statusCode}'));
    }
    AuthentInfo authentInfo = AuthentInfo.fromJson(response.data);
    this.accounts.add(Account(login: login, password: pass, userId: authentInfo.userId, name: name));
    tokens[authentInfo.userId] = authentInfo.token;
    return authentInfo;
  }
}