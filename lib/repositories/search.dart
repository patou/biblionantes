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
    final response =
    await client.post('https://catalogue-bm.nantes.fr/in/rest/api/search',
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: '{"query":["orgue"], "queryid":"NONE","includeFacets":false,"pageSize":10,"locale":"fr"}');

    if (response.statusCode != 200) {
      throw FetchDataException(
          'error occurred when fetch beers from punk API: {$response.statusCode}');
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Book>((json) => Book.fromJson(json)).toList();
  }
}