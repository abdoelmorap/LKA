class GalleryModel {
  GalleryModel({
    this.data,
  });
  List<Data> data;

  GalleryModel.fromJson(Map<String, dynamic> json) {
    data = List.from(json["DATA"]).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['DATA'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    this.id,
    this.image,
    this.content,
    this.studentId,
    this.createdAt,
    this.updateAt,
    this.updatedAt,
  });
  int id;
  String image;
  String content;
  int studentId;
  String createdAt;
  String updateAt;
  String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    content = json['content'];
    studentId = json['student_id'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['image'] = image;
    _data['content'] = content;
    _data['student_id'] = studentId;
    _data['created_at'] = createdAt;
    _data['update_at'] = updateAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
