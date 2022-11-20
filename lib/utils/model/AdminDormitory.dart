class AdminDormitory {
  String title;
  dynamic id;

  AdminDormitory({this.title, this.id});

  factory AdminDormitory.fromJson(Map<String, dynamic> json) {
    return AdminDormitory(
      title: json['dormitory_name'],
      id: json['id'],
    );
  }
}

class AdminDormitoryList {
  List<AdminDormitory> dormitories;

  AdminDormitoryList(this.dormitories);

  factory AdminDormitoryList.fromJson(List<dynamic> jsonArr) {
    List<AdminDormitory> dormitoryList = [];

    dormitoryList = jsonArr.map((i) => AdminDormitory.fromJson(i)).toList();

    return AdminDormitoryList(dormitoryList);
  }
}
