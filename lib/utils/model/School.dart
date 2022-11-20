class School {
  String name;
  dynamic id;
  String isEnabled;

  School({this.name, this.id,this.isEnabled});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
        name: json['school_name'],
        isEnabled: json['is_enabled'],
        id: json['id']);
  }
}

class SchoolList {

  List<School> schools = [];

//  static List<School> schoolList(){
//    List<School> schools = List<School>();
//    schools.add(School(name:"a School",id:1));
//    schools.add(School(name:"b School",id:2));
//    schools.add(School(name:"c School",id:3));
//    return schools;
//  }

  SchoolList(this.schools);

  factory SchoolList.fromJson(List<dynamic> json) {
    List<School> classList;

    classList = json.map((i) => School.fromJson(i)).toList();

    return SchoolList(classList);
  }
}
