import 'package:meta/meta.dart';

@immutable
class Book {
  int id;
  String title;
  String type;
  String description;
  String imageURL;

  Book({
    @required this.id,
    @required this.title,
    this.type,
    this.description,
    @required this.imageURL
  }): assert(id != null);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['LocalNumber']['value'] as int,
      title: json['title']['value'] as String,
      type: json['zmatIndex']['value'] as String,
      description: '',
      imageURL: 'https://catalogue-bm.nantes.fr/${json['imageSource_512']['value']}',
    );
  }
}