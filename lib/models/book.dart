import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Book extends Equatable {
  String id;
  String localNumber;
  String title;
  String type;
  String description;
  String imageURL;

  Book({
    required this.id,
    required this.localNumber,
    required this.title,
    required this.type,
    required this.description,
    required this.imageURL
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

  @override
  List<Object> get props => [id, localNumber, title, type, description, imageURL];
}