// Dart imports:
import 'dart:convert';

ClassExamSchedule classExamScheduleFromJson(String str) => ClassExamSchedule.fromJson(json.decode(str));

String classExamScheduleToJson(ClassExamSchedule data) => json.encode(data.toJson());

class ClassExamSchedule {
  ClassExamSchedule({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<ClassExamList> data;
  dynamic message;

  factory ClassExamSchedule.fromJson(Map<String, dynamic> json) => ClassExamSchedule(
    success: json["success"],
    data: List<ClassExamList>.from(json["data"].map((x) => ClassExamList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class ClassExamList {
  ClassExamList({
    this.examId,
    this.examName,
  });

  dynamic examId;
  String examName;

  factory ClassExamList.fromJson(Map<String, dynamic> json) => ClassExamList(
    examId: json["exam_id"],
    examName: json["exam_name"],
  );

  Map<String, dynamic> toJson() => {
    "exam_id": examId,
    "exam_name": examName,
  };
}
