class LeaveType {
  String type;
  dynamic id;
  dynamic days;

  LeaveType({this.type, this.id, this.days});

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(id: json['id'], type: json['type'], days: json['days']);
  }
}

class LeaveList {
  List<LeaveType> types;

  LeaveList(this.types);

  factory LeaveList.fromJson(List<dynamic> json) {
    List<LeaveType> leaveTypeList = [];
    leaveTypeList = json.map((i) => LeaveType.fromJson(i)).toList();
    return LeaveList(leaveTypeList);
  }
}
