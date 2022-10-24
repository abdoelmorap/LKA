class Teacher {
  String teacherName;
  String teacherEmail;
  String teacherPhone;

  Teacher({this.teacherName, this.teacherEmail,this.teacherPhone});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherName: json['full_name'],
      teacherEmail: json['email'],
      teacherPhone: json['mobile'],
    );
  }
}

class TeacherList {
  List<Teacher> teachers;

  TeacherList(this.teachers);

  factory TeacherList.fromJson(List<dynamic> json) {
    List<Teacher> teachers = [];

    teachers = json.map((i) => Teacher.fromJson(i)).toList();

    return TeacherList(teachers);
  }
}
