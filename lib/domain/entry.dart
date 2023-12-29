class Entry {
  late int id;
  late String title;
  late String content;
  late List<String> tags;
  late bool private;
  late List<String> imageUrls;

  static int idCount = 1;

  Entry({required this.id, required this.title, required this.content, required this.tags, required this.private, required this.imageUrls});

  Entry.withNewID({required this.title, required this.content, required this.tags, required this.private, required this.imageUrls}) {
    id = idCount;
    idCount++;
  }

  factory Entry.fromJSON(Map<String, dynamic> jsonMap) {
    return Entry(id: jsonMap['id'],
        title: jsonMap['title'],
        content: jsonMap['content'],
        tags: jsonMap['tags'],
        private: jsonMap['private'],
        imageUrls: jsonMap['imageUrls']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'content' : content,
      'tags' : tags,
      'private': private,
      'imageUrls': imageUrls
    };
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    var entry = other as Entry;
    return entry.id == id;
  }

  @override
  String toString() {
    return """{
      id : $id,
      title : $title,
      content : $content,
      tags : $tags,
      private: $private,
      imageUrls: $imageUrls
    }""";
  }
}