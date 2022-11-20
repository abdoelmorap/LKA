class StudentAttendance{
  String type;
  String date;

  StudentAttendance({this.type, this.date});

  factory StudentAttendance.fromJson(Map<String , dynamic> json){
    return StudentAttendance(
    type: json['attendance_type'],
    date: json['attendance_date'],
    );
  }
}

class StudentAttendanceList{

  List<StudentAttendance> attendances;

  StudentAttendanceList(this.attendances);

  factory StudentAttendanceList.fromJson(List<dynamic> json){

    List<StudentAttendance> studentAttendanceList = [];

    studentAttendanceList = json.map((i) => StudentAttendance.fromJson(i)).toList();

    return StudentAttendanceList(studentAttendanceList);
  }

}
