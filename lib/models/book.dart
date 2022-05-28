import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Book extends Equatable {
  final String id;
  final String? localNumber;
  final String title;
  final String? type;
  final String? creators;
  final String? imageURL;
  final String? ark;
  final bool? available;

  const Book({
    required this.id,
    this.localNumber,
    required this.title,
    this.type,
    this.imageURL,
    this.creators,
    this.available,
    this.ark,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'][0]['value'] as String,
      title: json['title'][0]['value'] as String,
      localNumber: json['LocalNumber'] != null ? json['LocalNumber'][0]['value'] as String : null,
      type: json['zmatIndex'][0]['value'] as String,
      creators: decodeCreators(json),
      imageURL: 'https://catalogue-bm.nantes.fr${json['imageSource_128'][0]['value']}',
    );
  }

  Book copyWith({
    String? id,
    String? localNumber,
    String? title,
    String? type,
    String? imageURL,
    String? creators,
    String? ark,
    bool? available,
  }) {
    return Book(id: id ?? this.id,
        localNumber: localNumber ?? this.localNumber,
        title: title ?? this.title,
        type: type ?? this.type,
        imageURL: imageURL ?? this.imageURL,
        creators: creators ?? this.creators,
        ark: ark ?? this.ark,
        available: available ?? this.available,
    );

  }

  static decodeCreators(json) {
    try {
      if (json['meta']['creator'] != null) {
        return json['meta']['creator'].map((json) => json['value']).join("; ");
      }
    }
    catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  List<Object?> get props => [id, localNumber, title, type, creators, imageURL, available];
}

@immutable
class Detail extends Equatable {
  final String display;
  final String value;
  final IconData? icon;
  final int order;


  const Detail({required this.display, required this.value, this.icon, this.order = 2});

  @override
  List<Object?> get props => [display, value, icon];
}

@immutable
class Stock extends Equatable {
  final String branch;
  final String subloca;
  final String category;
  final String collection;
  final String callnumber;
  final String status;
  final String stat;
  final bool isReserved;
  final DateTime? duedate;


  const Stock({
    required this.branch,
    required this.subloca,
    required this.category,
    required this.collection,
    required this.callnumber,
    required this.status,
    required this.stat,
    required this.isReserved,
    this.duedate,
  });

  @override
  List<Object?> get props => [branch, subloca, category, collection, callnumber, status, stat, isReserved, duedate];
}

@immutable
class BookDetail extends Equatable {
  final Book book;
  final List<Detail> details;
  final List<Stock> stock;

  const BookDetail({required this.book, this.details = const [], this.stock = const []});

  BookDetail copyWith({
    Book? book,
    List<Detail>? details,
    List<Stock>? stock,
  }) {
    final detailsList = [...this.details];
    if (details != null) {
      detailsList.addAll(details);
    }
    detailsList.sort((d1, d2) => d1.order.compareTo(d2.order));
    return BookDetail(
        book: book ?? this.book,
        details: detailsList,
        stock: stock ?? this.stock,
    );
  }

  @override
  List<Object?> get props => [book, details, stock];
}