import 'package:biblionantes/models/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FetchDataException implements Exception {
  final _message;
  final _prefix = 'Error during HTTP call: ';

  FetchDataException([this._message]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

@immutable
class SearchRepository {
  final Dio client;

  const SearchRepository({required this.client});

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
      bool? available = response.data[book.id]?['isAvailable'];
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
      return Future.error(FetchDataException('error occurred when get meta : {$response.statusCode}'));
    }
    Map<String, Map<String, dynamic>> summary = Map.fromIterable(response.data['summary'], key: (json) => json['name']);
    var creators = List.from(response.data['summary']).where((item) => item['name'] == 'meta.creator').toList();
    var book = Book(
        id: id,
        ark: summary['ark']?['value'],
        title: summary['title']?['value'],
        type: summary['zmatIndex']?['value'],
        localNumber: summary['LocalNumber']?['value'],
        creators: creators.map((item) => item['value']).join(', '),
        imageURL: 'https://catalogue-bm.nantes.fr${summary['imageSource_128']?['value']}');
    var details = <Detail>[];
    if (creators.isNotEmpty) {
      details.addAll(creators.map((item) => Detail(display: item['display'], value: item['value'], icon: Icons.person, order: 1)).toList());
    }
    if (summary['meta.publicationStatement'] != null) {
      details.add(Detail(display: summary['meta.publicationStatement']?['display'], value: summary['meta.publicationStatement']?['value'], icon: Icons.publish, order: 3));
    }
    return BookDetail(book: book, details: details);
  }

  Future<List<Detail>> info(String ark) async {
    final response = await client.get('resolveArk', queryParameters: {
      'ark': ark
    });
    if (response.statusCode != 200) {
      print("error");
      return Future.error(FetchDataException('error occurred when get info on book: {$response.statusCode}'));
    }
    var details = <Detail>[];
    if (response.data['collectionData'] != null) {
      final data = response.data['collectionData'];
      if (data['abstract'] != null) {
        details.add(Detail(display: "Résumé", value: data['abstract'], order: 0));
      }
      if (data['descriptionPhysical'] != null) {
        details.add(Detail(display: "Description", value: data['descriptionPhysical'], icon: Icons.format_size, order: 5));
      }
      if (data['noteTargetAudience'] != null) {
        details.add(Detail(display: "Public concerné", value: data['noteTargetAudience'], icon: Icons.child_care, order: 4));
      }
      if (data['relationSet'] != null) {
        details.add(Detail(display: "Titre de la série", value: data['relationSet']['DocumentCaption'], icon: Icons.format_list_numbered, order: 3));
      }
      if (data['subjectGeneral'] != null) {
        details.add(Detail(display: "Sujet", value: data['subjectGeneral'].map((item) => item['DocumentCaption']).join(', '), icon: Icons.subject, order: 3));
      }
    }
    return details;
  }

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
