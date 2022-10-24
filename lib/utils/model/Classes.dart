class Classes {
  String name;
  int id;

  Classes({this.name, this.id});

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      name: json['class_name'],
      id: int.parse(json['class_id'].toString()),
    );
  }
}

class ClassList {
  List<Classes> classes = [];

  ClassList(this.classes);

  factory ClassList.fromJson(List<dynamic> json) {
    List<Classes> classList;

    classList = json.map((i) => Classes.fromJson(i)).toList();

    return ClassList(classList);
  }
}
class AdminClasses {
  String name;
  int id;

  AdminClasses({this.name, this.id});

  factory AdminClasses.fromJson(Map<String, dynamic> json) {
    return AdminClasses(
      name: json['class_name'],
      id: int.parse(json['id'].toString()),
    );
  }
}

class AdminClassList {
  List<AdminClasses> classes = [];

  AdminClassList(this.classes);

  factory AdminClassList.fromJson(List<dynamic> json) {
    List<AdminClasses> classList;

    classList = json.map((i) => AdminClasses.fromJson(i)).toList();

    return AdminClassList(classList);
  }
}
