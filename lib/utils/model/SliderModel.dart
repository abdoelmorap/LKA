// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

// Dart imports:
import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  SliderData data;
  dynamic message;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        success: json["success"],
        data: SliderData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class SliderData {
  SliderData({
    this.appSliders,
  });

  List<AppSlider> appSliders;

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        appSliders: List<AppSlider>.from(
                json["appSliders"].map((x) => AppSlider.fromJson(x)))
            .where((element) => element.activeStatus == 1).toList(),
      );

  Map<String, dynamic> toJson() => {
        "appSliders": List<dynamic>.from(appSliders.map((x) => x.toJson())).where((element) => element.activeStatus == 1).toList(),
      };
}

class AppSlider {
  AppSlider({
    this.id,
    this.title,
    this.sliderImage,
    this.url,
    this.activeStatus,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String sliderImage;
  String url;
  int activeStatus;
  dynamic schoolId;
  DateTime createdAt;
  DateTime updatedAt;

  factory AppSlider.fromJson(Map<String, dynamic> json) => AppSlider(
        id: json["id"],
        title: json["title"],
        sliderImage: json["slider_image"],
        url: json["url"],
        activeStatus: json["active_status"],
        schoolId: json["school_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slider_image": sliderImage,
        "url": url,
        "active_status": activeStatus,
        "school_id": schoolId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
