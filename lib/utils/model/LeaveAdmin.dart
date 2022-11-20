class LeaveAdmin{

  dynamic id;
  String applyDate;
  String leaveFrom;
  String leaveTo;
  String reason;
  String status;
  String type;
  String file;
  String fullName;

  LeaveAdmin({this.id, this.applyDate, this.leaveFrom, this.leaveTo, this.reason,
      this.status,this.type,this.file,this.fullName});

  factory LeaveAdmin.fromJson(Map<String,dynamic> json){
    return LeaveAdmin(
      id: json['id'],
      applyDate: json['apply_date'],
      leaveFrom: json['leave_from'],
      leaveTo: json['leave_to'],
      status: json['approve_status'],
      reason: json['reason'] ?? '',
      type: json['type'] ?? '',
      file: json['file'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

class LeaveAdminList{

  List<LeaveAdmin> leaves;

  LeaveAdminList(this.leaves);
  
  factory LeaveAdminList.fromJson(List<dynamic> json){

    List<LeaveAdmin> leaveList = [];
    
    leaveList = json.map((i) => LeaveAdmin.fromJson(i)).toList();
    
    return LeaveAdminList(leaveList);
    
  }
  
}
