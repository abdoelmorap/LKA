class Child {
  dynamic id;
  dynamic uid;
  String photo;
  String name;
  List<String> classSections;

  Child({
    this.id,
    this.uid,
    this.photo,
    this.name,
    this.classSections,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      uid: json['user_id'],
      photo: json['photo'],
      name: json['full_name'],
      classSections: List<String>.from(json["class_section"].map((x) => x)),
    );
  }
}

class ChildList {
  List<Child> students;

  ChildList(this.students);

  factory ChildList.fromJson(List<dynamic> json) {
    List<Child> studentlist = [];

    studentlist = json.map((i) => Child.fromJson(i)).toList();

    return ChildList(studentlist);
  }
}
