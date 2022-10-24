class Student {
  dynamic id;
  dynamic uid;
  String photo;
  String name;
  String classSection;

  Student({
    this.id,
    this.photo,
    this.name,
    this.classSection,
    this.uid,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      photo: json['photo'],
      name: json['full_name'],
      classSection: json['class_section'],
      uid: json['user_id'],
    );
  }
}

class StudentList {
  List<Student> students;

  StudentList(this.students);

  factory StudentList.fromJson(List<dynamic> json) {
    List<Student> studentlist = [];

    studentlist = json.map((i) => Student.fromJson(i)).toList();

    return StudentList(studentlist);
  }
}
