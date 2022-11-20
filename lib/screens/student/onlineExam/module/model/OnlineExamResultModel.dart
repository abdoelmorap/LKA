// To parse this JSON data, do
//
//     final onlineExamResult = onlineExamResultFromJson(jsonString);

import 'dart:convert';

OnlineExamResultModel onlineExamResultFromJson(String str) =>
    OnlineExamResultModel.fromJson(json.decode(str));

String onlineExamResultToJson(OnlineExamResultModel data) =>
    json.encode(data.toJson());

class OnlineExamResultModel {
  OnlineExamResultModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  dynamic message;

  factory OnlineExamResultModel.fromJson(Map<String, dynamic> json) =>
      OnlineExamResultModel(
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
    this.studentExams,
  });

  List<StudentExam> studentExams;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        studentExams: List<StudentExam>.from(
            json["student_exams"].map((x) => StudentExam.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "student_exams":
            List<dynamic>.from(studentExams.map((x) => x.toJson())),
      };
}

class StudentExam {
  StudentExam({
    this.title,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.totalMarks,
    this.obtainMarks,
    this.result,
  });

  String title;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  int totalMarks;
  String obtainMarks;
  String result;

  factory StudentExam.fromJson(Map<String, dynamic> json) => StudentExam(
        title: json["title"],
        startDate: json["start_date"],
        startTime: json["start_time"],
        endDate: json["end_date"],
        endTime: json["end_time"],
        totalMarks: json["total_marks"],
        obtainMarks: json["obtain_marks"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "start_date": startDate,
        "start_time": startTime,
        "end_date": endDate,
        "end_time": endTime,
        "total_marks": totalMarks,
        "obtain_marks": obtainMarks,
        "result": result,
      };
}
