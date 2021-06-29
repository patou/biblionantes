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

  Future<Book> detail(String id) async {
    final response =
    await client.get('notice',
        queryParameters: {
          'id': id
        });
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException(
          'error occurred when search books: {$response.statusCode}'));
    }
    Map<String, Map<String, dynamic>> summary = Map.fromIterable(response.data['summary'], key: (json) => json['name']);
    var book = Book(
        id: id,
        title: summary['title']?['value'],
        type: summary['zmatIndex']?['value'],
        localNumber: summary['LocalNumber']?['value'],
        creators: summary['meta.creator']?['value'],
        imageURL: 'https://catalogue-bm.nantes.fr${summary['imageSource_128']?['value']}'
    );
    return book;
  }

  Map<String, dynamic> find(List<Map<String, dynamic>> list, String name) {
    return list.firstWhere((element) => element['name'] == name);
  }
}