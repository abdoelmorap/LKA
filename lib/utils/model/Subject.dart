class Subject {
  String subjectName;
  String teacherName;
  String subjectType;
  String subjectCode;

  Subject({
    this.subjectName,
    this.teacherName,
    this.subjectType,
    this.subjectCode,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectName: json['subject_name'],
      teacherName: json['teacher_name'],
      subjectType: json['subject_type'],
      subjectCode: json['subject_code'] ?? "",
    );
  }
}

class SubjectList {
  List<Subject> subjects;

  SubjectList(this.subjects);

  factory SubjectList.fromJson(List<dynamic> json) {
    List<Subject> subjects = [];

    subjects = json.map((i) => Subject.fromJson(i)).toList();

    return SubjectList(subjects);
  }
}
