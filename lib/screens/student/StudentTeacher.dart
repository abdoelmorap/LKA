// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:infixedu/controller/user_controller.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/model/Teacher.dart';
import 'package:infixedu/utils/widget/Student_teacher_row_layout.dart';

// ignore: must_be_immutable
class StudentTeacher extends StatefulWidget {
  String id;
  String token;

  StudentTeacher({this.id, this.token});

  @override
  _StudentTeacherState createState() => _StudentTeacherState();
}

class _StudentTeacherState extends State<StudentTeacher>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.put(UserController());
  Future<TeacherList> teachers;
  dynamic mId;
  dynamic perm = -1;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records.first;

    Utils.getStringValue('id').then((value) {
      setState(() {
        mId = widget.id != null ? int.parse(widget.id) : int.parse(value);
        teachers = getAllTeacher(
            mId, _userController.studentRecord.value.records.first.id);
      });
    });
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Teacher'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentRecordWidget(
              onTap: (Record record) async {
                _userController.selectedRecord.value = record;
                setState(
                  () {
                    teachers = getAllTeacher(mId, record.id);
                  },
                );
              },
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: FutureBuilder<TeacherList>(
                  future: teachers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data.teachers.length > 0) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data.teachers.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                thickness: 1.0,
                              );
                            },
                            itemBuilder: (context, index) {
                              return StudentTeacherRowLayout(
                                  snapshot.data.teachers[index], perm);
                            },
                          );
                        } else {
                          return Utils.noDataWidget();
                        }
                      } else {
                        return Center(child: CupertinoActivityIndicator());
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<TeacherList> getAllTeacher(dynamic id, int recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentTeacherUrl(
            _userController.schoolId.value, id, recordId)),
        headers: Utils.setHeader(widget.token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TeacherList.fromJson(jsonData['data']['teacher_list']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
