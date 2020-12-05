import 'package:meta/meta.dart';

@immutable
class Book {
  int id;
  String name;
  String tagline;
  String description;
  String imageURL;

  Book({
    @required this.id,
    @required this.name,
    this.tagline,
    this.description,
    @required this.imageURL
  }): assert(id != null);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      imageURL: json['image_url'] as String,
    );
  }
}