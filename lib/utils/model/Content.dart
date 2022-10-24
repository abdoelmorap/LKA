class Content {
  int id;
  String contentTitle;
  String contentType;
  String availableFor;
  String uploadDate;
  dynamic description;
  dynamic sourceUrl;
  String uploadFile;

  Content({
    this.id,
    this.contentTitle,
    this.contentType,
    this.availableFor,
    this.uploadDate,
    this.description,
    this.sourceUrl,
    this.uploadFile,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json["id"],
      contentTitle: json["title"],
      contentType: json["type"],
      availableFor: json["available_for"],
      uploadDate: json["upload_date"],
      description: json["description"],
      sourceUrl: json["source_url"],
      uploadFile: json["upload_file"],
    );
  }
}

class ContentList {
  List<Content> contents;

  ContentList(this.contents);

  factory ContentList.fromJson(List<dynamic> json) {
    List<Content> contentList = [];

    contentList = json.map((i) => Content.fromJson(i)).toList();

    return ContentList(contentList);
  }
}
