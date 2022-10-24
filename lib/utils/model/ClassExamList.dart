// To parse this JSON data, do
//
//     final classExam = classExamFromJson(jsonString);

// Dart imports:
import 'dart:convert';

ClassExam classExamFromJson(String str) => ClassExam.fromJson(json.decode(str));

String classExamToJson(ClassExam data) => json.encode(data.toJson());

class ClassExam {
  ClassExam({
    this.success,
    this.exams,
    this.message,
  });

  bool success;
  List<Exam> exams;
  dynamic message;

  factory ClassExam.fromJson(Map<String, dynamic> json) => ClassExam(
    success: json["success"],
    exams: List<Exam>.from(json["data"].map((x) => Exam.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(exams.map((x) => x.toJson())),
    "message": message,
  };
}

class Exam {
  Exam({
    this.id,
    this.examName,
    this.subjectName,
    this.date,
    this.roomNo,
    this.startTime,
    this.endTime,
  });

  dynamic id;
  String examName;
  String subjectName;
  dynamic date;
  String roomNo;
  String startTime;
  String endTime;

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: json["id"],
    examName: json["exam_name"],
    subjectName: json["subject_name"],
    date: json["date"],
    roomNo: json["room_no"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "exam_name": examName,
    "subject_name": subjectName,
    "date": date,
    "room_no": roomNo,
    "start_time": startTime,
    "end_time": endTime,
  };
}
