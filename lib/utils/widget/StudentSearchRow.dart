// Flutter imports:
import 'package:flutter/material.dart';
import 'package:infixedu/config/app_config.dart';

// Project imports:
import 'package:infixedu/screens/student/Profile.dart';
import 'package:infixedu/screens/student/StudentAttendance.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Student.dart';
import 'ScaleRoute.dart';

// ignore: must_be_immutable
class StudentRow extends StatefulWidget {
  Student student;
  String status;
  String token;

  StudentRow(this.student, {this.status, this.token});

  @override
  _StudentRowState createState() =>
      _StudentRowState(student, status: status, token: token);
}

class _StudentRowState extends State<StudentRow> {
  Student student;
  String status;
  String token;

  _StudentRowState(this.student, {this.status, this.token});

  @override
  void initState() {
    print(student);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String image = student.photo == null || student.photo == ''
        ? '${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg'
        : InfixApi.root + student.photo;
    return InkWell(
      onTap: () {
        if (status == 'attendance') {
          Navigator.push(
              context,
              ScaleRoute(
                  page: StudentAttendanceScreen(
                id: student.uid,
                token: token,
              )));
        } else {
          Navigator.push(
              context,
              ScaleRoute(
                  page: Profile(
                id: student.uid.toString(),
                image: image,
              )));
        }
      },
      splashColor: Colors.purple.shade200,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              student.name,
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text('${student.classSection}',
                style: Theme.of(context).textTheme.headline4),
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
      ),
    );
  }
}
