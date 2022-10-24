class Attendance {
  dynamic id;
  dynamic recordId;
  dynamic uid;
  dynamic sId;
  String photo;
  String name;
  dynamic roll;
  dynamic classId;
  dynamic sectionId;
  String className;
  String sectionName;
  String attendanceType;

  Attendance({
    this.id,
    this.recordId,
    this.sId,
    this.photo,
    this.name,
    this.roll,
    this.classId,
    this.sectionId,
    this.className,
    this.sectionName,
    this.attendanceType,
    this.uid,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      recordId: json['record_id'],
      sId: json['student_id'],
      photo: json['student_photo'],
      name: json['full_name'],
      roll: json['roll_no'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      className: json['class_name'],
      sectionName: json['section_name'],
      attendanceType: json['attendance_type'],
      uid: json['user_id'],
    );
  }
}

class AttendanceList {
  List<Attendance> attendances;

  AttendanceList(this.attendances);

  factory AttendanceList.fromJson(List<dynamic> json) {
    List<Attendance> attendanceList = [];

    attendanceList = json.map((i) => Attendance.fromJson(i)).toList();

    return AttendanceList(attendanceList);
  }
}
