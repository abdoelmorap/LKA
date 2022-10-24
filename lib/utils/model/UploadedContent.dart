class UploadedContent {
  UploadedContent({
    this.contentTitle,
    this.uploadDate,
    this.description,
    this.uploadFile,
    this.sourceUrl,
  });

  String contentTitle;
  String uploadDate;
  String description;
  String uploadFile;
  String sourceUrl;

  factory UploadedContent.fromJson(Map<String, dynamic> json) => UploadedContent(
    contentTitle: json["content_title"],
    uploadDate: json["upload_date"],
    description: json["description"],
    uploadFile: json["upload_file"],
    sourceUrl: json["source_url"],
  );

  Map<String, dynamic> toJson() => {
    "content_title": contentTitle,
    "upload_date": uploadDate,
    "description": description,
    "upload_file": uploadFile,
    "source_url": sourceUrl,
  };
}
class UploadedContentList {
  List<UploadedContent> uploadedContents;

  UploadedContentList(this.uploadedContents);

  factory UploadedContentList.fromJson(List<dynamic> json) {
    List<UploadedContent> uploadedContent = [];

    uploadedContent = json.map((i) => UploadedContent.fromJson(i)).toList();

    return UploadedContentList(uploadedContent);
  }
}
