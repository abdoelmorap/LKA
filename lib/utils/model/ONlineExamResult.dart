class OnlineExamResult {
  String subject;
  dynamic marks;
  dynamic passMarks;
  dynamic obtains;
  String grade;

  OnlineExamResult({this.subject, this.marks, this.obtains, this.passMarks, this.grade});

  factory OnlineExamResult.fromJson(Map<String, dynamic> json) {
    return OnlineExamResult(
        subject: json['subject_name'],
        marks: json['total_marks'],
        passMarks: json['pass_mark'],
        obtains: json['obtained_marks'],
        grade: json['grade']);
  }
}

class OnlineExamResultList {
  List<OnlineExamResult> results;

  OnlineExamResultList(this.results);

  factory OnlineExamResultList.fromJson(List<dynamic> json) {
    List<OnlineExamResult> resultList = [];

    resultList = json.map((i) => OnlineExamResult.fromJson(i)).toList();

    return OnlineExamResultList(resultList);
  }
}

class OnlineExamName {
  var title;
  var id;

  OnlineExamName({this.title, this.id});

  factory OnlineExamName.fromJson(Map<String, dynamic> json) {
    return OnlineExamName(title: json['exam_name'], id: json['exam_id']);
  }
}

class OnlineExamNameList {
  List<OnlineExamName> names;

  OnlineExamNameList(this.names);

  factory OnlineExamNameList.fromJson(List<dynamic> json) {
    List<OnlineExamName> resultList = [];

    resultList = json.map((i) => OnlineExamName.fromJson(i)).toList();

    return OnlineExamNameList(resultList);
  }
}
