class StudentMyLeaves {
  dynamic id;
  String type;
  dynamic days;

  StudentMyLeaves({
    this.id,
    this.type,
    this.days,
  });

  factory StudentMyLeaves.fromJson(Map<String, dynamic> json) {
    return StudentMyLeaves(
      id: json['id'],
      type: json['type'],
      days: json['days'],
    );
  }
}

class StudentMyLeavesList {
  List<StudentMyLeaves> studentMyLeave;

  StudentMyLeavesList(this.studentMyLeave);

  factory StudentMyLeavesList.fromJson(List<dynamic> json) {
    List<StudentMyLeaves> myLeaveList = [];

    myLeaveList = json.map((i) => StudentMyLeaves.fromJson(i)).toList();

    return StudentMyLeavesList(myLeaveList);
  }
}

class StudentApplyLeaves {
  dynamic id;
  String type;
  String applyDate;
  String leaveFrom;
  String leaveTo;
  String approveStatus;
  dynamic activeStatus;

  StudentApplyLeaves({
    this.id,
    this.type,
    this.applyDate,
    this.leaveFrom,
    this.leaveTo,
    this.approveStatus,
    this.activeStatus,
  });

  factory StudentApplyLeaves.fromJson(Map<String, dynamic> json) {
    return StudentApplyLeaves(
      id: json['id'],
      type: json['type'],
      applyDate: json['apply_date'],
      leaveFrom: json['leave_from'],
      leaveTo: json['leave_to'],
      approveStatus: json['approve_status'],
      activeStatus: json['active_status'],
    );
  }
}

class StudentApplyLeavesList {
  List<StudentApplyLeaves> studentApplyLeave;

  StudentApplyLeavesList(this.studentApplyLeave);

  factory StudentApplyLeavesList.fromJson(List<dynamic> json) {
    List<StudentApplyLeaves> studentApplyLeaveList = [];

    studentApplyLeaveList =
        json.map((i) => StudentApplyLeaves.fromJson(i)).toList();

    return StudentApplyLeavesList(studentApplyLeaveList);
  }
}
