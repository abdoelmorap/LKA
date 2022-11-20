import 'package:get/get.dart';

class AttendanceController extends GetxController {
  RxMap<String, AttendanceValue> attendanceMap =
      <String, AttendanceValue>{}.obs;
}

class AttendanceValue {
  AttendanceValue({
    this.student,
    this.attendanceClass,
    this.section,
    this.attendanceType,
    this.note,
  });

  String student;
  String attendanceClass;
  String section;
  String attendanceType;
  dynamic note;

  factory AttendanceValue.fromJson(Map<String, dynamic> json) =>
      AttendanceValue(
        student: json["student"].toString(),
        attendanceClass: json["class"].toString(),
        section: json["section"].toString(),
        attendanceType: json["attendance_type"].toString(),
        note: json["note"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "student": student,
        "class": attendanceClass,
        "section": section,
        "attendance_type": attendanceType,
        "note": note,
      };
}
