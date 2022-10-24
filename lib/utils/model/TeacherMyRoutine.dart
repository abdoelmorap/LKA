// To parse this JSON data, do
//
//     final routine = routineFromJson(jsonString);

import 'dart:convert';

TeacherRoutine teacherRoutineFromJson(String str) =>
    TeacherRoutine.fromJson(json.decode(str));

String teacherRoutineToJson(TeacherRoutine data) => json.encode(data.toJson());

class TeacherRoutine {
  TeacherRoutine({
    this.staffDetail,
    this.classRoutines,
  });

  StaffDetail staffDetail;
  List<ClassRoutine> classRoutines;

  factory TeacherRoutine.fromJson(Map<String, dynamic> json) => TeacherRoutine(
        staffDetail: StaffDetail.fromJson(json["staff_detail"]),
        classRoutines: List<ClassRoutine>.from(
            json["class_routines"].map((x) => ClassRoutine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "staff_detail": staffDetail.toJson(),
        "class_routines":
            List<dynamic>.from(classRoutines.map((x) => x.toJson())),
      };
}

class ClassRoutine {
  ClassRoutine({
    this.id,
    this.day,
    this.room,
    this.subject,
    this.teacher,
    this.classRoutineClass,
    this.section,
    this.startTime,
    this.endTime,
    this.classRoutineBreak,
  });

  int id;
  String day;
  String room;
  String subject;
  String teacher;
  String classRoutineClass;
  String section;
  String startTime;
  String endTime;
  String classRoutineBreak;

  factory ClassRoutine.fromJson(Map<String, dynamic> json) => ClassRoutine(
        id: json["id"],
        day: json["day"],
        room: json["room"],
        subject: json["subject"],
        teacher: json["teacher"],
        classRoutineClass: json["class"],
        section: json["section"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        classRoutineBreak: json["break"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "room": room,
        "subject": subject,
        "teacher": teacher,
        "class": classRoutineClass,
        "section": section,
        "start_time": startTime,
        "end_time": endTime,
        "break": classRoutineBreak,
      };
}
class StaffDetail {
  StaffDetail({
    this.id,
    this.fullName,
  });

  int id;
  String fullName;

  factory StaffDetail.fromJson(Map<String, dynamic> json) => StaffDetail(
        id: json["id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
      };
}
