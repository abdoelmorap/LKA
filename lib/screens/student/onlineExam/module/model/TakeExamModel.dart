// To parse this JSON data, do
//
//     final takeExamModel = takeExamModelFromJson(jsonString);

import 'dart:convert';

TakeExamModel takeExamModelFromJson(String str) =>
    TakeExamModel.fromJson(json.decode(str));

String takeExamModelToJson(TakeExamModel data) => json.encode(data.toJson());

class TakeExamModel {
  TakeExamModel({
    this.onlineExam,
    this.examQuestions,
    this.totalQuestions,
    this.onlineExamSetting,
    this.totalExamMarks,
    this.page,
    this.recordId,
    this.questionType,
  });

  OnlineExam onlineExam;
  List<ExamQuestion> examQuestions;
  int totalQuestions;
  OnlineExamSetting onlineExamSetting;
  int totalExamMarks;
  int page;
  String recordId;
  List<String> questionType;

  factory TakeExamModel.fromJson(Map<String, dynamic> json) => TakeExamModel(
        onlineExam: OnlineExam.fromJson(json["online_exam"]),
        examQuestions: List<ExamQuestion>.from(
            json["exam_questions"].map((x) => ExamQuestion.fromJson(x))),
        totalQuestions: json["total_questions"],
        onlineExamSetting:
            OnlineExamSetting.fromJson(json["online_exam_setting"]),
        totalExamMarks: json["total_exam_marks"],
        page: json["page"],
        recordId: json["record_id"],
        questionType: List<String>.from(json["question_type"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "online_exam": onlineExam.toJson(),
        "exam_questions":
            List<dynamic>.from(examQuestions.map((x) => x.toJson())),
        "total_questions": totalQuestions,
        "online_exam_setting": onlineExamSetting.toJson(),
        "total_exam_marks": totalExamMarks,
        "page": page,
        "record_id": recordId,
        "question_type": List<dynamic>.from(questionType.map((x) => x)),
      };
}

class ExamQuestion {
  ExamQuestion({
    this.id,
    this.question,
    this.questionType,
    this.userAnswer,
    this.questionBankId,
    this.miImage,
    this.imqImage,
    this.imqQuestions,
    this.miQuestions,
    this.mQuestions,
    this.piQuestions,
  });

  int id;
  String question;
  String questionType;
  String userAnswer;
  int questionBankId;
  String miImage;
  String imqImage;
  List<ImqQuestion> imqQuestions;
  List<MiQuestion> miQuestions;
  List<MQuestion> mQuestions;
  List<PiQuestion> piQuestions;

  factory ExamQuestion.fromJson(Map<String, dynamic> json) => ExamQuestion(
        id: json["id"],
        question: json["question"],
        questionType: json["question_type"],
        userAnswer: json["user_answer"],
        questionBankId: json["question_bank_id"],
        miImage: json["mi_image"],
        imqImage: json["imq_image"],
        imqQuestions: json["imq_questions"] == null
            ? null
            : List<ImqQuestion>.from(
                json["imq_questions"].map((x) => ImqQuestion.fromJson(x))),
        miQuestions: json["imq_questions"] == null
            ? null
            : List<MiQuestion>.from(
                json["mi_questions"].map((x) => MiQuestion.fromJson(x))),
        mQuestions: json["imq_questions"] == null
            ? null
            : List<MQuestion>.from(
                json["m_questions"].map((x) => MQuestion.fromJson(x))),
        piQuestions: json["imq_questions"] == null
            ? null
            : List<PiQuestion>.from(
                json["pi_questions"].map((x) => PiQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "question_type": questionType,
        "user_answer": userAnswer,
        "question_bank_id": questionBankId,
        "mi_image": miImage,
        "imq_image": imqImage,
        "imq_questions":
            List<dynamic>.from(imqQuestions.map((x) => x.toJson())),
        "mi_questions": List<dynamic>.from(miQuestions.map((x) => x.toJson())),
        "m_questions": List<dynamic>.from(mQuestions.map((x) => x.toJson())),
        "pi_questions": List<dynamic>.from(piQuestions.map((x) => x.toJson())),
      };
}

class ImqQuestion {
  ImqQuestion({
    this.imqId,
    this.imqTitle,
    this.imqImageTitle,
  });

  int imqId;
  String imqTitle;
  String imqImageTitle;

  factory ImqQuestion.fromJson(Map<String, dynamic> json) => ImqQuestion(
        imqId: json["imq_id"],
        imqTitle: json["imq_title"],
        imqImageTitle: json["imq_image_title"],
      );

  Map<String, dynamic> toJson() => {
        "imq_id": imqId,
        "imq_title": imqTitle,
        "imq_image_title": imqImageTitle,
      };
}

class MQuestion {
  MQuestion({
    this.mId,
    this.mTitle,
    this.alphabet,
  });

  int mId;
  String mTitle;
  String alphabet;

  factory MQuestion.fromJson(Map<String, dynamic> json) => MQuestion(
        mId: json["m_id"],
        mTitle: json["m_title"],
        alphabet: json["alphabet"],
      );

  Map<String, dynamic> toJson() => {
        "m_id": mId,
        "m_title": mTitle,
        "alphabet": alphabet,
      };
}

class MiQuestion {
  MiQuestion({
    this.miId,
    this.miTitle,
  });

  int miId;
  String miTitle;

  factory MiQuestion.fromJson(Map<String, dynamic> json) => MiQuestion(
        miId: json["mi_id"],
        miTitle: json["mi_title"],
      );

  Map<String, dynamic> toJson() => {
        "mi_id": miId,
        "mi_title": miTitle,
      };
}

class PiQuestion {
  PiQuestion({
    this.pmId,
    this.pmTitle,
    this.pTitle,
  });

  int pmId;
  String pmTitle;
  String pTitle;

  factory PiQuestion.fromJson(Map<String, dynamic> json) => PiQuestion(
        pmId: json["pm_id"],
        pmTitle: json["pm_title"],
        pTitle: json["p_title"],
      );

  Map<String, dynamic> toJson() => {
        "pm_id": pmId,
        "pm_title": pmTitle,
        "p_title": pTitle,
      };
}

class OnlineExam {
  OnlineExam({
    this.id,
    this.title,
    this.date,
    this.endDate,
    this.startTime,
    this.endTime,
    this.endDateTime,
    this.percentage,
    this.examType,
    this.selectedSections,
    this.uniqueId,
    this.instruction,
    this.status,
    this.isTaken,
    this.isClosed,
    this.isWaiting,
    this.isRunning,
    this.autoMark,
    this.negativeMarking,
    this.activeStatus,
    this.durationType,
    this.duration,
    this.defaultQuestionTime,
    this.createdAt,
    this.updatedAt,
    this.classId,
    this.sectionId,
    this.subjectId,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.questionGroups,
    this.courseId,
    this.chapterId,
    this.lessonId,
  });

  int id;
  String title;
  DateTime date;
  DateTime endDate;
  String startTime;
  String endTime;
  DateTime endDateTime;
  int percentage;
  int examType;
  String selectedSections;
  String uniqueId;
  String instruction;
  int status;
  int isTaken;
  int isClosed;
  int isWaiting;
  int isRunning;
  int autoMark;
  int negativeMarking;
  int activeStatus;
  String durationType;
  int duration;
  int defaultQuestionTime;
  DateTime createdAt;
  DateTime updatedAt;
  int classId;
  int sectionId;
  int subjectId;
  int createdBy;
  int updatedBy;
  int schoolId;
  int academicId;
  String questionGroups;
  dynamic courseId;
  dynamic chapterId;
  dynamic lessonId;

  factory OnlineExam.fromJson(Map<String, dynamic> json) => OnlineExam(
        id: json["id"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        endDate: DateTime.parse(json["end_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        endDateTime: DateTime.parse(json["end_date_time"]),
        percentage: json["percentage"],
        examType: json["exam_type"],
        selectedSections: json["selected_sections"],
        uniqueId: json["unique_id"],
        instruction: json["instruction"],
        status: json["status"],
        isTaken: json["is_taken"],
        isClosed: json["is_closed"],
        isWaiting: json["is_waiting"],
        isRunning: json["is_running"],
        autoMark: json["auto_mark"],
        negativeMarking: json["negative_marking"],
        activeStatus: json["active_status"],
        durationType: json["duration_type"],
        duration: json["duration"],
        defaultQuestionTime: json["default_question_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        classId: json["class_id"],
        sectionId: json["section_id"],
        subjectId: json["subject_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        questionGroups: json["question_groups"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        lessonId: json["lesson_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "end_date_time": endDateTime.toIso8601String(),
        "percentage": percentage,
        "exam_type": examType,
        "selected_sections": selectedSections,
        "unique_id": uniqueId,
        "instruction": instruction,
        "status": status,
        "is_taken": isTaken,
        "is_closed": isClosed,
        "is_waiting": isWaiting,
        "is_running": isRunning,
        "auto_mark": autoMark,
        "negative_marking": negativeMarking,
        "active_status": activeStatus,
        "duration_type": durationType,
        "duration": duration,
        "default_question_time": defaultQuestionTime,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "class_id": classId,
        "section_id": sectionId,
        "subject_id": subjectId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
        "academic_id": academicId,
        "question_groups": questionGroups,
        "course_id": courseId,
        "chapter_id": chapterId,
        "lesson_id": lessonId,
      };
}

class OnlineExamSetting {
  OnlineExamSetting({
    this.id,
    this.autoMarkingDefault,
    this.negativeMarking,
    this.deductMarksPerWrong,
    this.submitFromLastPage,
    this.anyQuestionAccess,
    this.randomQuestion,
    this.singlePage,
    this.schoolId,
  });

  int id;
  int autoMarkingDefault;
  int negativeMarking;
  double deductMarksPerWrong;
  int submitFromLastPage;
  int anyQuestionAccess;
  int randomQuestion;
  int singlePage;
  int schoolId;

  factory OnlineExamSetting.fromJson(Map<String, dynamic> json) =>
      OnlineExamSetting(
        id: json["id"],
        autoMarkingDefault: json["auto_marking_default"],
        negativeMarking: json["negative_marking"],
        deductMarksPerWrong: json["deduct_marks_per_wrong"].toDouble(),
        submitFromLastPage: json["submit_from_last_page"],
        anyQuestionAccess: json["any_question_access"],
        randomQuestion: json["random_question"],
        singlePage: json["single_page"],
        schoolId: json["school_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "auto_marking_default": autoMarkingDefault,
        "negative_marking": negativeMarking,
        "deduct_marks_per_wrong": deductMarksPerWrong,
        "submit_from_last_page": submitFromLastPage,
        "any_question_access": anyQuestionAccess,
        "random_question": randomQuestion,
        "single_page": singlePage,
        "school_id": schoolId,
      };
}
