import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

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

  SearchRepository({required this.client});

  Future<List<Book>> search(String search, {int page = 1, int pageSize = 20}) async {
    final response =
    await client.post('search',
      data: {"query":[search], "queryid":"NONE","includeFacets":false,"pageSize":pageSize, "pageNo": page,"locale":"fr"});
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException(
          'error occurred when search books: {$response.statusCode}'));
    }

    var list = response.data['resultSet'].map<Book>((json) => Book.fromJson(json)).toList();
    return list;
  }

  Future<List<Book>> searchAvailability(List<Book> books) async {
    final ids = books.map((e) => e.id).join(",");
    final response =
    await client.get('stockAvailabilityFor',
        queryParameters: {
          "iids": ids,
        });
    if (response.statusCode != 200) {
      print("error");
      return books;
    }
    return books.map((book) {
      bool? available = response.data[book.id]?['isAvailable'] ?? null;
      return book.copyWith(available: available);
    }).toList();
  }
}