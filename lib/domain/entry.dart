class Entry {
  late int id;
  late String title;
  late String content;
  late List<String> tags;
  late bool private;
  late List<String> imageUrls;

  static int idCount = 1; //TODO shared preferences abspeichern
  static Entry defaultEntry = Entry(id: 0, title: "", content: "", tags: [], private: false, imageUrls: []);

  Entry({required this.id, required this.title, required this.content, required this.tags, required this.private, required this.imageUrls});

  Entry.withNewID({required this.title, required this.content, required this.tags, required this.private, required this.imageUrls}) {
    id = idCount;
    idCount++;
  }

  factory Entry.fromJSON(Map<String, dynamic> jsonMap) {
    List<dynamic> tags = jsonMap['tags'] ?? [];
    List<dynamic> imageUrls = jsonMap['imageUrls'] ?? [];

    return Entry(id: jsonMap['id'],
        title: jsonMap['title'],
        content: jsonMap['content'],
        tags: List.castFrom(tags),
        private: jsonMap['private'],
        imageUrls: List.castFrom(imageUrls),
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
  bool operator ==(Object other) {    //Equals
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