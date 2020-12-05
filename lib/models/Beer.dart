import 'package:meta/meta.dart';

@immutable
class Beer {
  int id;
  String name;
  String tagline;
  String description;
  String imageURL;

  Beer({
    @required this.id,
    @required this.name,
    this.tagline,
    this.description,
    @required this.imageURL
  }): assert(id != null);

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      imageURL: json['image_url'] as String,
    );
  }
}
