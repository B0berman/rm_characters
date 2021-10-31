class Location {
  final String name;
  final String url;

  Location(this.name, this.url);

  factory Location.fromJSON(Map<String, dynamic> json) {
    return Location(
      json['name'],
      json['url'],
    );
  }
}