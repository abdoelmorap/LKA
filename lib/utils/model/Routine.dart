// To parse this JSON data, do
//
//     final routine = routineFromJson(jsonString);

import 'dart:convert';

Routine routineFromJson(String str) => Routine.fromJson(json.decode(str));

String routineToJson(Routine data) => json.encode(data.toJson());

class Routine {
  Routine({
    this.studentDetail,
    this.classRoutines,
  });

  StudentDetail studentDetail;
  List<ClassRoutine> classRoutines;

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
        studentDetail: StudentDetail.fromJson(json["student_detail"]),
        classRoutines: List<ClassRoutine>.from(
            json["class_routines"].map((x) => ClassRoutine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "student_detail": studentDetail.toJson(),
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

  dynamic id;
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

class StudentDetail {
  StudentDetail({
    this.id,
    this.fullName,
    this.classId,
    this.sectionId,
  });

  dynamic id;
  String fullName;
  dynamic classId;
  dynamic sectionId;

  factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
        id: json["id"],
        fullName: json["full_name"],
        classId: json["class_id"],
        sectionId: json["section_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "class_id": classId,
        "section_id": sectionId,
      };
}
