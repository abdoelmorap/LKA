// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/model/Student.dart';
import 'package:infixedu/utils/widget/StudentSearchRow.dart';

// ignore: must_be_immutable
class StudentListScreen extends StatefulWidget {
  dynamic classCode;
  dynamic sectionCode;
  String name;
  String roll;
  String url;
  String status;
  String token;

  StudentListScreen(
      {this.classCode,
      this.sectionCode,
      this.name,
      this.roll,
      this.url,
      this.status,
      this.token});

  @override
  _StudentListScreenState createState() => _StudentListScreenState(
        classCode: classCode,
        sectionCode: sectionCode,
        name: name,
        roll: roll,
        url: url,
        status: status,
        token: token,
      );
}

class _StudentListScreenState extends State<StudentListScreen> {
  dynamic classCode;
  dynamic sectionCode;
  String name;
  String roll;
  String url;
  Future<StudentList> students;
  String status;
  String token;

  _StudentListScreenState(
      {this.classCode,
      this.sectionCode,
      this.name,
      this.roll,
      this.url,
      this.status,
      this.token});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      students = getAllStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Students List'),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<StudentList>(
        future: students,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.students.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.students.length,
                itemBuilder: (context, index) {
                  return StudentRow(
                    snapshot.data.students[index],
                    status: status,
                    token: token,
                  );
                },
              );
            } else {
              return Utils.noDataWidget();
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<StudentList> getAllStudent() async {
    print(url);
    final response = await http.get(Uri.parse(url),
        headers: Utils.setHeader(token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
