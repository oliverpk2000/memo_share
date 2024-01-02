class Entry {
  late int id;
  late String title;
  late String content;
  late List<String> tags;
  late bool private;
  late List<String> imageUrls;
  late DateTime created;
  late int creatorId;

  static int idCount = 1; //TODO shared preferences abspeichern
  static Entry defaultEntry = Entry(
      id: 0, title: "", content: "", tags: [], private: false, imageUrls: [], created: DateTime.now(), creatorId: -1);

  Entry(
      {required this.id,
      required this.title,
      required this.content,
      required this.tags,
      required this.private,
      required this.imageUrls,
      required this.created,
      required this.creatorId});

  Entry.withNewID(
      {required this.title,
      required this.content,
      required this.tags,
      required this.private,
      required this.imageUrls,
      required this.created,
      required this.creatorId}) {

    id = idCount;
    idCount++;
  }

  factory Entry.fromJSON(Map<String, dynamic> jsonMap) {
    List<dynamic> tags = jsonMap['tags'] ?? [];
    List<dynamic> imageUrls = jsonMap['imageUrls'] ?? [];

    return Entry(
      id: jsonMap['id'],
      title: jsonMap['title'],
      content: jsonMap['content'],
      tags: List.castFrom(tags),
      private: jsonMap['private'],
      imageUrls: List.castFrom(imageUrls),
      created: DateTime.parse(jsonMap['created']),
      creatorId: jsonMap['creatorId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'private': private,
      'imageUrls': imageUrls,
      'created': created.toString(),
      'creatorId' : creatorId
    };
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    //Equals
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
      imageUrls: $imageUrls,
      created : ${created.toString()},
      creator: $creatorId
    }""";
  }
}
