// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/teacher/attendance/attendance_controller.dart';

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/custom_widgets/CustomRadioButton/CustomButton/ButtonTextStyle.dart';
import 'package:infixedu/utils/custom_widgets/CustomRadioButton/custom_radio_button.dart';
import 'package:infixedu/utils/model/Attendance.dart';
import 'package:infixedu/utils/model/GlobalClass.dart';

// ignore: must_be_immutable
class StudentAttendanceRow extends StatefulWidget {
  // Student student;
  Attendance attendanceStudents;
  dynamic mClass, mSection;
  String date, token;

  StudentAttendanceRow(this.attendanceStudents, this.mClass, this.mSection,
      this.date, this.token);

  @override
  _StudentAttendanceRowState createState() => _StudentAttendanceRowState(
      attendanceStudents, mClass, mSection, date, token);
}

class _StudentAttendanceRowState extends State<StudentAttendanceRow> {
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());

  Attendance attendanceStudents;
  bool isSelected = true;
  dynamic mClass, mSection;
  String date;
  String atten = 'P';
  var function = GlobalDatae();
  Future<bool> isChecked;
  String token;

  Future getAttend;

  _StudentAttendanceRowState(this.attendanceStudents, this.mClass,
      this.mSection, this.date, this.token);

  @override
  void didChangeDependencies() {
    _attendanceController.attendanceMap.addAll({
      '${attendanceStudents.recordId}': AttendanceValue.fromJson({
        'student': attendanceStudents.sId.toString(),
        'class': attendanceStudents.classId.toString(),
        'section': attendanceStudents.sectionId.toString(),
        'attendance_type': attendanceStudents.attendanceType == null
            ? "P"
            : attendanceStudents.attendanceType,
      })
    });
    super.didChangeDependencies();

    // isChecked = checkAttendance();
    // isChecked.then((value){
    //   if(value){
    //     setDefaultAttendance();
    //   }
    // });
    // getAttend = getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    String image =
        attendanceStudents.photo == null || attendanceStudents.photo == ''
            ? '${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg'
            : InfixApi.root + attendanceStudents.photo;
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left: 8.0),
          leading: !isSelected
              ? CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.red.shade700,
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                )
              : CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(image),
                  backgroundColor: Colors.grey,
                ),
          title: Text(
            attendanceStudents.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Class : ${attendanceStudents.className} | Section : ${attendanceStudents.sectionName}',
                  style: Theme.of(context).textTheme.headline4),
              CustomRadioButton(
                defaultSelected: attendanceStudents.attendanceType == null
                    ? "P"
                    : attendanceStudents.attendanceType,
                elevation: 0,
                unSelectedColor: Colors.deepPurple.shade100,
                selectedColor: Colors.deepPurple,
                buttonLables: [
                  'Present',
                  'Late',
                  'Absent',
                  'Half Day',
                ],
                buttonValues: [
                  "P",
                  "L",
                  "A",
                  "H",
                ],
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Color(0xff415094),
                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(14))),
                radioButtonValue: (value) {
                  setState(() {
                    atten = value;
                    _attendanceController.attendanceMap.update(
                        attendanceStudents.recordId.toString(),
                        (value) => AttendanceValue(
                              student: attendanceStudents.sId.toString(),
                              section: attendanceStudents.sectionId.toString(),
                              attendanceClass:
                                  attendanceStudents.classId.toString(),
                              attendanceType: atten.toString(),
                            ));
                  });
                },
                enableShape: true,
                customShape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                horizontal: false,
                width: ScreenUtil().setWidth(65),
                height: ScreenUtil().setHeight(25),
                enableButtonWrap: false,
                wrapAlignment: WrapAlignment.start,
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.purple, Colors.deepPurple]),
          ),
        )
      ],
    );
  }

  void setAttendance() async {
    final response = await http.get(
        Uri.parse(InfixApi.attendanceDataSend('${attendanceStudents.sId}',
            atten, date, mClass, mSection, attendanceStudents.recordId)),
        headers: Utils.setHeader(token));
    print(response.request.url);
    if (response.statusCode == 200) {
      debugPrint('Attendance successful');
      Utils.showToast('Attendance set for ${attendanceStudents.name}');
    } else {
      throw Exception('Failed to load');
    }
  }

//  void setDefaultAttendance() async {
//    final response = await http.get(InfixApi.attendance_defalut_send(date, mClass, mSection));
//    if (response.statusCode == 200) {
//      debugPrint('Attendance default successful');
//    } else {
//      throw Exception('Failed to load');
//    }
//  }
  Future<bool> checkAttendance() async {
    final response = await http.get(
        Uri.parse(InfixApi.attendanceCheck(date, mClass, mSection)),
        headers: Utils.setHeader(token));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData['success'];
    } else {
      throw Exception('Failed to load');
    }
  }
}
