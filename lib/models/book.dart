import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Book extends Equatable {
  String id;
  String? localNumber;
  String title;
  String type;
  String? creators;
  String imageURL;
  bool? available;

  Book({
    required this.id,
    this.localNumber,
    required this.title,
    required this.type,
    required this.imageURL,
    this.creators,
    this.available,
  }): assert(id != null);

  factory Book.fromJson(Map<String, dynamic> json) {
    print(json['title'][0]['value']);
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
    bool? available,
  }) {
    return Book(id: id ?? this.id,
        localNumber: localNumber ?? this.localNumber,
        title: title ?? this.title,
        type: type ?? this.type,
        imageURL: imageURL ?? this.imageURL,
        creators: creators ?? this.creators,
        available: available ?? this.available,
    );

  }

  static decodeCreators(json) {
    try {
      return json['meta']['creator'].map((json) => json['value']).join("; ");
    }
    catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  String toString() {
    return 'Book{id: $id, localNumber: $localNumber, title: $title, type: $type, creators: $creators, imageURL: $imageURL, available: $available}';
  }

  @override
  List<Object?> get props => [id, localNumber, title, type, creators, imageURL, available];
}