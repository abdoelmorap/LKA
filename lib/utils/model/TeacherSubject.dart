class TeacherSubject {
  String subjectName;
  String subjectCode;
  String subjectType;
  int subjectId;

  TeacherSubject({this.subjectName, this.subjectCode, this.subjectType,this.subjectId});

  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    return TeacherSubject(
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
      subjectType: json['subject_type'],
      subjectId: json['subject_id'],
    );
  }
}

class TeacherSubjectList {
  List<TeacherSubject> subjects;

  TeacherSubjectList(this.subjects);

  factory TeacherSubjectList.fromJson(List<dynamic> json) {
    List<TeacherSubject> subjects = [];

    subjects = json.map((i) => TeacherSubject.fromJson(i)).toList();

    return TeacherSubjectList(subjects);
  }
}
