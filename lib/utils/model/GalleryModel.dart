class GalleryModel {
  GalleryModel({
    required this.data,
  });
  late final List<Data> data;

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
    required this.id,
    required this.image,
    required this.content,
    required this.studentId,
    required this.createdAt,
    required this.updateAt,
    required this.updatedAt,
  });
  late final int id;
  late final String image;
  late final String content;
  late final int studentId;
  late final String createdAt;
  late final String updateAt;
  late final String updatedAt;

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
