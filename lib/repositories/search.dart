import 'package:biblionantes/models/book.dart';
import 'package:dio/dio.dart';
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
  final Dio client;

  SearchRepository({@required this.client}) : assert(client != null);

  Future<List<Book>> search(String search) async {
    final response =
    await client.post('search',
      data: {"query":[search], "queryid":"NONE","includeFacets":false,"pageSize":10,"locale":"fr"});
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException(
          'error occurred when search books: {$response.statusCode}'));
    }

    var list = response.data['resultSet'].map<Book>((json) => Book.fromJson(json)).toList();
    return list;
  }
}