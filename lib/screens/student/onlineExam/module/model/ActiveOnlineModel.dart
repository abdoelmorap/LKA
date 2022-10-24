// To parse this JSON data, do
//
//     final activeOnlineModel = activeOnlineModelFromJson(jsonString);

import 'dart:convert';

ActiveOnlineModel activeOnlineModelFromJson(String str) =>
    ActiveOnlineModel.fromJson(json.decode(str));

String activeOnlineModelToJson(ActiveOnlineModel data) =>
    json.encode(data.toJson());

class ActiveOnlineModel {
  ActiveOnlineModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  dynamic message;

  factory ActiveOnlineModel.fromJson(Map<String, dynamic> json) =>
      ActiveOnlineModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.onlineExams,
    this.timeZone,
    this.onlineExamTakenStatus,
  });

  List<OnlineExam> onlineExams;
  bool timeZone;
  String onlineExamTakenStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        onlineExams: List<OnlineExam>.from(
            json["online_exams"].map((x) => OnlineExam.fromJson(x))),
        timeZone: json["time_zone"],
        onlineExamTakenStatus: json["onlineExamTakenStatus"],
      );

  Map<String, dynamic> toJson() => {
        "online_exams": List<dynamic>.from(onlineExams.map((x) => x.toJson())),
        "time_zone": timeZone,
        "onlineExamTakenStatus": onlineExamTakenStatus,
      };
}

class OnlineExam {
  OnlineExam({
    this.id,
    this.title,
    this.classId,
    this.sectionId,
    this.subjectId,
    this.onlineExamClass,
    this.section,
    this.subject,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.duration,
    this.percentage,
    this.status,
  });

  int id;
  String title;
  int classId;
  int sectionId;
  int subjectId;
  String onlineExamClass;
  String section;
  String subject;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  int duration;
  int percentage;
  String status;

  factory OnlineExam.fromJson(Map<String, dynamic> json) => OnlineExam(
        id: json["id"],
        title: json["title"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        subjectId: json["subject_id"],
        onlineExamClass: json["class"],
        section: json["section"],
        subject: json["subject"],
        startDate: json["start_date"],
        startTime: json["start_time"],
        endDate: json["end_date"],
        endTime: json["end_time"],
        duration: json["duration"],
        percentage: json["percentage"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "class_id": classId,
        "section_id": sectionId,
        "subject_id": subjectId,
        "class": onlineExamClass,
        "section": section,
        "subject": subject,
        "start_date": startDate,
        "start_time": startTime,
        "end_date": endDate,
        "end_time": endTime,
        "duration": duration,
        "percentage": percentage,
        "status": status,
      };
}
