import 'package:meta/meta.dart';

@immutable
class Book {
  String id;
  String localNumber;
  String title;
  String type;
  String description;
  String imageURL;

  Book({
    @required this.id,
    this.localNumber,
    @required this.title,
    this.type,
    this.description,
    this.imageURL
  }): assert(id != null);

  factory Book.fromJson(Map<String, dynamic> json) {
    print(json['title'][0]['value']);
    return Book(
      id: json['id'][0]['value'] as String,
      title: json['title'][0]['value'] as String,
      localNumber: json['LocalNumber'][0]['value'] as String,
      type: json['zmatIndex'][0]['value'] as String,
      description: '',
      imageURL: 'https://catalogue-bm.nantes.fr${json['imageSource_128'][0]['value']}',
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, localNumber: $localNumber, title: $title, type: $type, description: $description, imageURL: $imageURL}';
  }
}