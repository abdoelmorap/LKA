

class Staff {
  dynamic id;
  String name;
  String qualification;
  String currentAddress;
  String title;
  String maritalStatus;
  String dateOfJoining;
  String phone;
  String photo;
  dynamic userId;

  Staff(
      {this.id,
      this.name,
      this.qualification,
      this.currentAddress,
      this.title,
      this.maritalStatus,
      this.dateOfJoining,
      this.phone,
      this.photo,
        this.userId,
      });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['full_name'],
      qualification: json['qualification'],
      currentAddress: json['current_address'],
      title: json['title'],
      maritalStatus: json['marital_status'],
      dateOfJoining: json['date_of_joining'],
      phone: json['mobile'],
      photo: json['staff_photo'],
      userId: json['user_id'],
    );
  }
}

class StaffList {

  List<Staff> staffs;

  StaffList(this.staffs);

  factory StaffList.fromJson(List<dynamic> json) {
    List<Staff> staffList = [];

    staffList = json.map((i) => Staff.fromJson(i)).toList();
    return StaffList(staffList);
  }
}
