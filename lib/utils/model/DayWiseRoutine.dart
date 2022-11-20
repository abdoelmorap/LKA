// To parse this JSON data, do
//
//     final dayWiseRoutine = dayWiseRoutineFromJson(jsonString);

import 'dart:convert';

DayWiseRoutine dayWiseRoutineFromJson(String str) => DayWiseRoutine.fromJson(json.decode(str));

String dayWiseRoutineToJson(DayWiseRoutine data) => json.encode(data.toJson());

class DayWiseRoutine {
    DayWiseRoutine({
        this.dayId,
        this.classRoutines,
        this.smWeekends,
        this.subjects,
        this.rooms,
        this.teachers,
        this.sectionId,
        this.classId,
    });

    String dayId;
    List<ClassRoutine> classRoutines;
    List<SmWeekend> smWeekends;
    List<Subject> subjects;
    List<Room> rooms;
    List<Teacher> teachers;
    String sectionId;
    String classId;

    factory DayWiseRoutine.fromJson(Map<String, dynamic> json) => DayWiseRoutine(
        dayId: json["day_id"],
        classRoutines: List<ClassRoutine>.from(json["class_routines"].map((x) => ClassRoutine.fromJson(x))),
        smWeekends: List<SmWeekend>.from(json["sm_weekends"].map((x) => SmWeekend.fromJson(x))),
        subjects: List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))),
        rooms: List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
        teachers: List<Teacher>.from(json["teachers"].map((x) => Teacher.fromJson(x))),
        sectionId: json["section_id"],
        classId: json["class_id"],
    );

    Map<String, dynamic> toJson() => {
        "day_id": dayId,
        "class_routines": List<dynamic>.from(classRoutines.map((x) => x.toJson())),
        "sm_weekends": List<dynamic>.from(smWeekends.map((x) => x.toJson())),
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
        "rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
        "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
        "section_id": sectionId,
        "class_id": classId,
    };
}

class ClassRoutine {
    ClassRoutine({
        this.id,
        this.day,
        this.activeStatus,
        this.createdAt,
        this.updatedAt,
        this.roomId,
        this.teacherId,
        this.classPeriodId,
        this.subjectId,
        this.classId,
        this.sectionId,
        this.createdBy,
        this.updatedBy,
        this.schoolId,
        this.academicId,
        this.startTime,
        this.endTime,
        this.isBreak,
    });

    int id;
    int day;
    int activeStatus;
    DateTime createdAt;
    DateTime updatedAt;
    int roomId;
    int teacherId;
    dynamic classPeriodId;
    int subjectId;
    int classId;
    int sectionId;
    int createdBy;
    int updatedBy;
    int schoolId;
    int academicId;
    String startTime;
    String endTime;
    dynamic isBreak;

    factory ClassRoutine.fromJson(Map<String, dynamic> json) => ClassRoutine(
        id: json["id"],
        day: json["day"],
        activeStatus: json["active_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roomId: json["room_id"],
        teacherId: json["teacher_id"],
        classPeriodId: json["class_period_id"],
        subjectId: json["subject_id"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        isBreak: json["is_break"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "active_status": activeStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "room_id": roomId,
        "teacher_id": teacherId,
        "class_period_id": classPeriodId,
        "subject_id": subjectId,
        "class_id": classId,
        "section_id": sectionId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
        "academic_id": academicId,
        "start_time": startTime,
        "end_time": endTime,
        "is_break": isBreak,
    };
}

class Room {
    Room({
        this.id,
        this.roomNo,
        this.capacity,
        this.activeStatus,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.schoolId,
        this.academicId,
    });

    int id;
    String roomNo;
    int capacity;
    int activeStatus;
    DateTime createdAt;
    DateTime updatedAt;
    int createdBy;
    int updatedBy;
    int schoolId;
    int academicId;

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        roomNo: json["room_no"],
        capacity: json["capacity"],
        activeStatus: json["active_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "room_no": roomNo,
        "capacity": capacity,
        "active_status": activeStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
        "academic_id": academicId,
    };
}

class SmWeekend {
    SmWeekend({
        this.id,
        this.name,
        this.order,
        this.isWeekend,
    });

    int id;
    String name;
    int order;
    int isWeekend;

    factory SmWeekend.fromJson(Map<String, dynamic> json) => SmWeekend(
        id: json["id"],
        name: json["name"],
        order: json["order"],
        isWeekend: json["is_weekend"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "order": order,
        "is_weekend": isWeekend,
    };
}

class Subject {
    Subject({
        this.id,
        this.subjectName,
        this.subjectCode,
        this.subjectType,
    });

    int id;
    String subjectName;
    String subjectCode;
    String subjectType;

    factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"],
        subjectName: json["subject_name"],
        subjectCode: json["subject_code"],
        subjectType: json["subject_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
        "subject_code": subjectCode,
        "subject_type": subjectType,
    };
}

class Teacher {
    Teacher({
        this.id,
        this.fullName,
        this.userId,
        this.schoolId,
    });

    int id;
    String fullName;
    int userId;
    int schoolId;

    factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        fullName: json["full_name"],
        userId: json["user_id"],
        schoolId: json["school_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "user_id": userId,
        "school_id": schoolId,
    };
}
