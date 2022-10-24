// To parse this JSON data, do
//
//     final planDetails = planDetailsFromJson(jsonString);

import 'dart:convert';

List<PlanDetails> planDetailsFromJson(String str) => List<PlanDetails>.from(json.decode(str).map((x) => PlanDetails.fromJson(x)));

String planDetailsToJson(List<PlanDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanDetails {
    PlanDetails({
        this.day,
        this.room,
        this.subject,
        this.teacher,
        this.startTime,
        this.endTime,
        this.planDetailBreak,
        this.plan,
        this.subTopicEnabled,
    });

    String day;
    String room;
    String subject;
    String teacher;
    String startTime;
    String endTime;
    String planDetailBreak;
    Plan plan;
    bool subTopicEnabled;

    factory PlanDetails.fromJson(Map<String, dynamic> json) => PlanDetails(
        day: json["day"],
        room: json["room"],
        subject: json["subject"],
        teacher: json["teacher"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        planDetailBreak: json["break"],
        plan:json["plan"] == null ? null : Plan.fromJson(json["plan"]),
        subTopicEnabled: json["subTopicEnabled"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "room": room,
        "subject": subject,
        "teacher": teacher,
        "start_time": startTime,
        "end_time": endTime,
        "break": planDetailBreak,
        "plan": plan.toJson(),
        "subTopicEnabled": subTopicEnabled,
    };
}

class Plan {
    Plan({
        this.id,
        this.day,
        this.activeStatus,
        this.createdAt,
        this.updatedAt,
        this.lessonId,
        this.topicId,
        this.lessonDetailId,
        this.topicDetailId,
        this.subTopic,
        this.lectureYouubeLink,
        this.lectureVedio,
        this.attachment,
        this.teachingMethod,
        this.generalObjectives,
        this.previousKnowlege,
        this.compQuestion,
        this.zoomSetup,
        this.presentation,
        this.note,
        this.lessonDate,
        this.competedDate,
        this.completedStatus,
        this.roomId,
        this.teacherId,
        this.classPeriodId,
        this.subjectId,
        this.classId,
        this.sectionId,
        this.createdBy,
        this.updatedBy,
        this.routineId,
        this.schoolId,
        this.academicId,
        this.topics,
        this.lessonName,
    });

    int id;
    int day;
    int activeStatus;
    DateTime createdAt;
    DateTime updatedAt;
    int lessonId;
    dynamic topicId;
    int lessonDetailId;
    int topicDetailId;
    dynamic subTopic;
    String lectureYouubeLink;
    dynamic lectureVedio;
    String attachment;
    dynamic teachingMethod;
    dynamic generalObjectives;
    dynamic previousKnowlege;
    dynamic compQuestion;
    dynamic zoomSetup;
    dynamic presentation;
    dynamic note;
    DateTime lessonDate;
    dynamic competedDate;
    dynamic completedStatus;
    dynamic roomId;
    int teacherId;
    dynamic classPeriodId;
    int subjectId;
    int classId;
    int sectionId;
    int createdBy;
    int updatedBy;
    int routineId;
    int schoolId;
    int academicId;
    List<Topic> topics;
    LessonName lessonName;

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        day: json["day"],
        activeStatus: json["active_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        lessonId: json["lesson_id"],
        topicId: json["topic_id"],
        lessonDetailId: json["lesson_detail_id"],
        topicDetailId: json["topic_detail_id"],
        subTopic: json["sub_topic"],
        lectureYouubeLink: json["lecture_youube_link"],
        lectureVedio: json["lecture_vedio"],
        attachment: json["attachment"],
        teachingMethod: json["teaching_method"],
        generalObjectives: json["general_objectives"],
        previousKnowlege: json["previous_knowlege"],
        compQuestion: json["comp_question"],
        zoomSetup: json["zoom_setup"],
        presentation: json["presentation"],
        note: json["note"],
        lessonDate: DateTime.parse(json["lesson_date"]),
        competedDate: json["competed_date"],
        completedStatus: json["completed_status"],
        roomId: json["room_id"],
        teacherId: json["teacher_id"],
        classPeriodId: json["class_period_id"],
        subjectId: json["subject_id"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        routineId: json["routine_id"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        topics: List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
        lessonName: LessonName.fromJson(json["lesson_name"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "active_status": activeStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "lesson_id": lessonId,
        "topic_id": topicId,
        "lesson_detail_id": lessonDetailId,
        "topic_detail_id": topicDetailId,
        "sub_topic": subTopic,
        "lecture_youube_link": lectureYouubeLink,
        "lecture_vedio": lectureVedio,
        "attachment": attachment,
        "teaching_method": teachingMethod,
        "general_objectives": generalObjectives,
        "previous_knowlege": previousKnowlege,
        "comp_question": compQuestion,
        "zoom_setup": zoomSetup,
        "presentation": presentation,
        "note": note,
        "lesson_date": "${lessonDate.year.toString().padLeft(4, '0')}-${lessonDate.month.toString().padLeft(2, '0')}-${lessonDate.day.toString().padLeft(2, '0')}",
        "competed_date": competedDate,
        "completed_status": completedStatus,
        "room_id": roomId,
        "teacher_id": teacherId,
        "class_period_id": classPeriodId,
        "subject_id": subjectId,
        "class_id": classId,
        "section_id": sectionId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "routine_id": routineId,
        "school_id": schoolId,
        "academic_id": academicId,
        "topics": List<dynamic>.from(topics.map((x) => x.toJson())),
        "lesson_name": lessonName.toJson(),
    };
}

class LessonName {
    LessonName({
        this.id,
        this.lessonTitle,
        this.activeStatus,
        this.classId,
        this.sectionId,
        this.subjectId,
        this.schoolId,
        this.academicId,
        this.userId,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String lessonTitle;
    int activeStatus;
    int classId;
    int sectionId;
    int subjectId;
    int schoolId;
    int academicId;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;

    factory LessonName.fromJson(Map<String, dynamic> json) => LessonName(
        id: json["id"],
        lessonTitle: json["lesson_title"],
        activeStatus: json["active_status"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        subjectId: json["subject_id"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lesson_title": lessonTitle,
        "active_status": activeStatus,
        "class_id": classId,
        "section_id": sectionId,
        "subject_id": subjectId,
        "school_id": schoolId,
        "academic_id": academicId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Topic {
    Topic({
        this.id,
        this.subTopicTitle,
        this.topicId,
        this.lessonPlannerId,
        this.createdAt,
        this.updatedAt,
        this.topicName,
    });

    int id;
    String subTopicTitle;
    int topicId;
    int lessonPlannerId;
    DateTime createdAt;
    DateTime updatedAt;
    TopicName topicName;

    factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        subTopicTitle: json["sub_topic_title"],
        topicId: json["topic_id"],
        lessonPlannerId: json["lesson_planner_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        topicName: TopicName.fromJson(json["topic_name"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sub_topic_title": subTopicTitle,
        "topic_id": topicId,
        "lesson_planner_id": lessonPlannerId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "topic_name": topicName.toJson(),
    };
}

class TopicName {
    TopicName({
        this.id,
        this.lessonId,
        this.topicTitle,
        this.completedStatus,
        this.competedDate,
        this.activeStatus,
        this.topicId,
        this.createdBy,
        this.updatedBy,
        this.schoolId,
        this.academicId,
        this.userId,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int lessonId;
    String topicTitle;
    dynamic completedStatus;
    dynamic competedDate;
    int activeStatus;
    int topicId;
    int createdBy;
    int updatedBy;
    int schoolId;
    int academicId;
    dynamic userId;
    DateTime createdAt;
    DateTime updatedAt;

    factory TopicName.fromJson(Map<String, dynamic> json) => TopicName(
        id: json["id"],
        lessonId: json["lesson_id"],
        topicTitle: json["topic_title"],
        completedStatus: json["completed_status"],
        competedDate: json["competed_date"],
        activeStatus: json["active_status"],
        topicId: json["topic_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lesson_id": lessonId,
        "topic_title": topicTitle,
        "completed_status": completedStatus,
        "competed_date": competedDate,
        "active_status": activeStatus,
        "topic_id": topicId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
        "academic_id": academicId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
