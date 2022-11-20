// To parse this JSON data, do
//
//     final examRoutineReport = examRoutineReportFromJson(jsonString);

import 'dart:convert';

ExamRoutineReport examRoutineReportFromJson(String str) => ExamRoutineReport.fromJson(json.decode(str));

String examRoutineReportToJson(ExamRoutineReport data) => json.encode(data.toJson());

class ExamRoutineReport {
    ExamRoutineReport({
        this.examType,
        this.examRoutines,
    });

    ExamType examType;
    Map<String, List<ExamRoutine>> examRoutines;

    factory ExamRoutineReport.fromJson(Map<String, dynamic> json) => ExamRoutineReport(
        examType: ExamType.fromJson(json["examType"]),
        examRoutines: Map.from(json["exam_routines"]).map((k, v) => MapEntry<String, List<ExamRoutine>>(k, List<ExamRoutine>.from(v.map((x) => ExamRoutine.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "examType": examType.toJson(),
        "exam_routines": Map.from(examRoutines).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    };
}

class ExamRoutine {
  ExamRoutine({
    this.id,
    this.date,
    this.className,
    this.section,
    this.room,
    this.subject,
    this.teacher,
    this.examType,
    this.startTime,
    this.endTime,
  });

  int id;
  DateTime date;
  String className;
  String section;
  String room;
  String subject;
  String teacher;
  String examType;
  String startTime;
  String endTime;

  factory ExamRoutine.fromJson(Map<String, dynamic> json) => ExamRoutine(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        className: json["class"],
        section: json["section"],
        room: json["room"],
        subject: json["subject"],
        teacher: json["teacher"],
        examType: json["exam_type"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "class": className,
        "section": section,
        "room": room,
        "subject": subject,
        "teacher": teacher,
        "exam_type": examType,
        "start_time": startTime,
        "end_time": endTime,
      };
}

class ExamType {
  ExamType({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory ExamType.fromJson(Map<String, dynamic> json) => ExamType(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
