// Dart imports:
import 'dart:convert';
import 'dart:developer';

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
import 'package:infixedu/utils/model/StudentHomework.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/widget/Homework_row.dart';

// ignore: must_be_immutable
class StudentHomework extends StatefulWidget {
  String id;

  StudentHomework({this.id});

  @override
  _StudentHomeworkState createState() => _StudentHomeworkState();
}

class _StudentHomeworkState extends State<StudentHomework> {
  final UserController _userController = Get.put(UserController());
  Future<HomeworkList> homeworks;
  String _token;
  String _id;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records.first;
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    Utils.getStringValue('id').then((idValue) {
      setState(() {
        _id = idValue;
        print(_id);
        homeworks = fetchHomework(
          widget.id != null ? int.parse(widget.id) : int.parse(idValue),
          _userController.studentRecord.value.records.first.id,
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Homeworks'),
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
                    homeworks = fetchHomework(
                        widget.id != null
                            ? int.parse(widget.id)
                            : int.parse(_id),
                        record.id);
                  },
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<HomeworkList>(
                future: homeworks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    if (snapshot.hasData && snapshot != null) {
                      if (snapshot.data.homeworks.length > 0) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemCount: snapshot.data.homeworks.length,
                          itemBuilder: (context, index) {
                            return StudentHomeworkRow(
                                snapshot.data.homeworks[index], 'student');
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<HomeworkList> fetchHomework(int userId, recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudenthomeWorksUrl(userId, recordId)),
        headers: Utils.setHeader(_token.toString()));
    log(response.request.url.path);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return HomeworkList.fromJson(jsonData['data']);
    } else {
      throw Exception('failed to load');
    }
  }
}
