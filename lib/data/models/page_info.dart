class PageInfo {
  final int count;
  final int pages;
  final String next;
  final String prev;

  PageInfo({this.count = 0, this.pages = 0, this.next = "1", this.prev = ""});

  factory PageInfo.fromJSON(Map<String, dynamic> json) {
    return PageInfo(
      count: json['count'],
      pages: json['pages'],
      next: json['next'] ?? "last",
      prev: json['prev'] ?? "",
    );
  }
}