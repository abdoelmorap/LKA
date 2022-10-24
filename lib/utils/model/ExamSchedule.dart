// To parse this JSON data, do
//
//     final examSchedule = examScheduleFromJson(jsonString);

import 'dart:convert';

import 'ExamRoutineReport.dart';

ExamSchedule examScheduleFromJson(String str) => ExamSchedule.fromJson(json.decode(str));

String examScheduleToJson(ExamSchedule data) => json.encode(data.toJson());

class ExamSchedule {
    ExamSchedule({
        this.examTypes,
        this.studentDetail,
    });

    List<ExamType> examTypes;
    StudentDetail studentDetail;

    factory ExamSchedule.fromJson(Map<String, dynamic> json) => ExamSchedule(
        examTypes: List<ExamType>.from(json["exam_types"].map((x) => ExamType.fromJson(x))),
        studentDetail: StudentDetail.fromJson(json["student_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "exam_types": List<dynamic>.from(examTypes.map((x) => x.toJson())),
        "student_detail": studentDetail.toJson(),
    };
}

class StudentDetail {
    StudentDetail({
        this.id,
        this.fullName,
        this.classId,
        this.sectionId,
        this.userId,
    });

    dynamic id;
    String fullName;
    dynamic classId;
    dynamic sectionId;
    dynamic userId;

    factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
        id: json["id"],
        fullName: json["full_name"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "class_id": classId,
        "section_id": sectionId,
        "user_id": userId,
    };
}
