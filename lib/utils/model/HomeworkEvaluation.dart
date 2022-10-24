class StudentHomeworkEvaluation {
  dynamic id;
  String homeworkDate;
  String submissionDate;
  String evaluationDate;
  String createdBy;
  String homeworkDetailClass;
  String section;
  String subjectName;
  String marks;
  String file;
  String description;

  StudentHomeworkEvaluation(
      {this.id,
        this.homeworkDate,
        this.submissionDate,
        this.evaluationDate,
        this.createdBy,
        this.homeworkDetailClass,
        this.section,
        this.subjectName,
        this.marks,
        this.file,
        this.description,});

  factory StudentHomeworkEvaluation.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkEvaluation(
      id: json["id"],
      homeworkDate: json["homework_date"],
      submissionDate: json["submission_date"],
      evaluationDate: json["evaluation_date"],
      createdBy: json["created_by"],
      homeworkDetailClass: json["class"],
      section: json["section"],
      subjectName: json["subject_name"],
      marks: json["marks"],
      file: json["file"],
      description: json["description"],
    );
  }
}

class StudentEvaluation {
  StudentEvaluation({
    this.id,
    this.studentId,
    this.studentName,
    this.admissionNo,
    this.homeworkId,
    this.marks,
    this.teacherComments,
    this.completeStatus,
    this.file,
    this.evaluationStatus,
  });

  dynamic id;
  dynamic studentId;
  String studentName;
  dynamic admissionNo;
  dynamic homeworkId;
  dynamic marks;
  String teacherComments;
  String completeStatus;
  String evaluationStatus;
  dynamic file;

  // ignore: missing_return
  factory StudentEvaluation.fromJson(Map<String, dynamic> json) => StudentEvaluation(
    id: json["id"],
    studentId: json["student_id"],
    studentName: json["student_name"],
    admissionNo: json["admission_no"],
    homeworkId: json["homework_id"],
    marks: json["marks"],
    teacherComments: json["teacher_comments"],
    completeStatus: json["complete_status"],
    evaluationStatus: json["evaluation_status"],
    file: List<String>.from(json["file"].map((x) => x)) ?? "",
  );
}



class StudentEvaluationList {
  List<StudentEvaluation> studentEvaluation;
  StudentEvaluationList(this.studentEvaluation);
  factory StudentEvaluationList.fromJson(List<dynamic> json) {
    List<StudentEvaluation> studentEvaluationList = [];
    studentEvaluationList = json.map((i) => StudentEvaluation.fromJson(i)).toList();
    return StudentEvaluationList(studentEvaluationList);
  }
}
