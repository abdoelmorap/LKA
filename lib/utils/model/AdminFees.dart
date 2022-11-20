class AdminFees {
  dynamic id;
  String name;
  String description;

  AdminFees({this.id, this.name, this.description});

  factory AdminFees.fromJson(Map<String, dynamic> json) {
    return AdminFees(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class AdminFeesList {
  List<AdminFees> adminFees;

  AdminFeesList(this.adminFees);

  factory AdminFeesList.fromjson(List<dynamic> json) {
    List<AdminFees> adminFeeList = [];

    adminFeeList = json.map((i) => AdminFees.fromJson(i)).toList();

    return AdminFeesList(adminFeeList);
  }
}
