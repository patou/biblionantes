import 'package:biblionantes/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class FetchDataException implements Exception {
  final _message;
  final _prefix = 'Error during HTTP call: ';

  FetchDataException([this._message]);

  String toString() {
    return "$_prefix$_message";
  }
}

@immutable
class SearchRepository {
  final http.Client client;

  SearchRepository({@required this.client}) : assert(client != null);

  Future<List<Book>> search(String search) async {
    var searchBody = '{"query":["$search"], "queryid":"NONE","includeFacets":false,"pageSize":10,"locale":"fr"}';
    final response =
    await client.post('https://catalogue-bm.nantes.fr/in/rest/api/search',
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
      body: searchBody);
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException(
          'error occurred when search books: {$response.statusCode}'));
    }

    final parsed = jsonDecode(response.body).cast<String, dynamic>();
    var list = parsed['resultSet'].map<Book>((json) => Book.fromJson(json)).toList();
    return list;
  }
}