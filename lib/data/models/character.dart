import 'package:rm_characters/data/models/location.dart';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final Location origin;
  final Location location;
  final String image;
  final String url;

  Character(this.id, this.name, this.status, this.species, this.type, this.gender,
       this.origin, this.location, this.image, this.url);

  factory Character.fromJSON(Map<String, dynamic> json) {
    return Character(
      json['id'],
      json['name'],
      json['status'],
      json['species'],
      json['type'],
      json['gender'],
      Location.fromJSON(json['origin']),
      Location.fromJSON(json['location']),
      json['image'],
      json['url'],
    );
  }
}