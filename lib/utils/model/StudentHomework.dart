class Homework {
  dynamic id;
  String description;
  String subjectName;
  String homeworkDate;
  String submissionDate;
  String evaluationDate;
  String fileUrl;
  String status;
  String marks;
  dynamic classId;
  dynamic sectionId;
  dynamic subjectId;
  String obtainedMarks;

  Homework(
      {this.id,this.description,
      this.subjectName,
      this.homeworkDate,
      this.submissionDate,
      this.evaluationDate,
      this.fileUrl,
      this.status,
      this.marks,this.classId,this.sectionId,this.subjectId,this.obtainedMarks});

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'],
      description: json['description'],
      subjectName: json['subject_name'],
      homeworkDate: json['homework_date'],
      submissionDate: json['submission_date'],
      evaluationDate: json['evaluation_date'],
      fileUrl: json['file'],
      status: json['status'],
      marks: json['marks'],
      obtainedMarks: json['obtained_marks'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      subjectId: json['subject_id'],
    );
  }
}

class HomeworkList {
  List<Homework> homeworks;

  HomeworkList(this.homeworks);

  factory HomeworkList.fromJson(List<dynamic> json) {
    List<Homework> homeworklist = [];

    homeworklist = json.map((i) => Homework.fromJson(i)).toList();

    return HomeworkList(homeworklist);
  }
}
