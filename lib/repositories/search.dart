import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    final response = await client.post('search', data: {
      "query": [search],
      "queryid": "NONE",
      "includeFacets": false,
      "pageSize": pageSize,
      "pageNo": page,
      "locale": "fr"
    });
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException('error occurred when search books: {$response.statusCode}'));
    }

    var list = response.data['resultSet'].map<Book>((json) => Book.fromJson(json)).toList();
    return list;
  }

  Future<List<Book>> searchAvailability(List<Book> books) async {
    final ids = books.map((e) => e.id).join(",");
    final response = await client.get('stockAvailabilityFor', queryParameters: {
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

  Future<BookDetail> detail(String id) async {
    final response = await client.get('notice', queryParameters: {
      'id': id,
      'aspect': 'Meta',
    });
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException('error occurred when search books: {$response.statusCode}'));
    }
    Map<String, Map<String, dynamic>> summary = Map.fromIterable(response.data['summary'], key: (json) => json['name']);
    var creators = List.from(response.data['summary']).where((item) => item['name'] == 'meta.creator').toList();
    print(creators);
    var book = Book(
        id: id,
        ark: summary['ark']?['value'],
        title: summary['title']?['value'],
        type: summary['zmatIndex']?['value'],
        localNumber: summary['LocalNumber']?['value'],
        creators: creators.map((item) => item['value']).join(', '),
        imageURL: 'https://catalogue-bm.nantes.fr${summary['imageSource_128']?['value']}');
    var details = <Detail>[];
    if (creators.isNotEmpty)
      details.addAll(creators.map((item) => Detail(display: item['display'], value: item['value'], icon: Icons.person)).toList());
    if (summary['meta.publicationStatement'] != null)
      details.add(Detail(display: summary['meta.publicationStatement']?['display'], value: summary['meta.publicationStatement']?['value'], icon: Icons.publish));
    return BookDetail(book: book, details: details);
  }

  /**
   * branch: "CHA"
      branch_desc: "Chantenay"
      callnumber: "R JAY 1"
      category: "LJ"
      category_desc: "Livre Jeunesse"
      collection: "RP"
      collection_desc: "Roman policier"
      copyCanReserve: "true"
      copyNumber: "1667377"
      document: "00004004085672"
      dueDate: "20210609"
      flagReserved: "false"
      isReserved: "false"
      itemType: "monographic"
      recordCanReserve: "true"
      recordHasMonographic: "true"
      recordHasSerialHoldings: "false"
      recordHasSerialIssues: "false"
      recordNo: "810534"
      resv_cur: "0"
      source: "PWS"
      stat: "EP"
      stat_desc: "Prêté"
      subloca: "EFI"
      subloca_desc: "Espace littérature"
   */
  Future<List<Stock>> stock(String id) async {
    final response = await client.get('notice', queryParameters: {
      'id': id,
      'aspect': 'Stock',
      'locale': 'fr',
    });
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException('error occurred when search books: {$response.statusCode}'));
    }
    var result = <Stock>[];
    response.data['monographicCopies']
        .forEach((element) => element['children']
            .forEach((item) {
              result.add(Stock(
                  branch: item['data']['branch_desc'] ?? "",
                  subloca: item['data']['subloca_desc'] ?? "",
                  category: item['data']['category_desc'] ?? "",
                  collection: item['data']['collection_desc'] ?? "",
                  status: item['data']['stat_desc'] ?? "",
                  stat: item['data']['stat'] ?? "",
                  isReserved: item['data']?['isReserved'] == "true",
                  callnumber: item['data']['callnumber'] ?? "",
                  duedate: DateTime.tryParse(item['data']['dueDate'] ?? ""),
                ));
            })
        );
    return result;
  }
}
