import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:http/http.dart' as http;
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
  final http.Client client;

  AccountRepository({@required this.client}) : assert(client != null);

  List<Account> accounts = List();

  List<Account> getAccounts() {
    return this.accounts;
  }

  Future<AuthentInfo> addAccount(String login, String pass) async {
    final response =
        await client.post('https://catalogue-bm.nantes.fr/in/rest/api/authenticate',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: '{"username":"$login","password":"$pass","birthdate":"","locale":"fr"}'
        );

    if (response.statusCode != 200) {
      throw AuthenticateException(
          'error occurred when authenticate: {$response.statusCode}');
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    AuthentInfo authentInfo = AuthentInfo.fromJson(parsed);
    this.accounts.add(Account(login: login, password: pass, userId: authentInfo.userId));
    return authentInfo;
  }
}