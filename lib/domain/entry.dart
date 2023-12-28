class Entry{
  late int id;
  late String title;
  late String content;
  late List<String> tags;
  late bool private;
  late List<String> imageUrls;

  Entry(this.id, this.title, this.content, this.tags, this.private, this.imageUrls);
}