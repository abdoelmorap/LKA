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
import 'package:infixedu/utils/model/ActiveOnlineExam.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/widget/ActiveOnlineExam.dart';

// ignore: must_be_immutable
class ActiveOnlineExamScreen extends StatefulWidget {
  var id;

  ActiveOnlineExamScreen({this.id});

  @override
  _ActiveOnlineExamScreenState createState() =>
      _ActiveOnlineExamScreenState(id: id);
}

class _ActiveOnlineExamScreenState extends State<ActiveOnlineExamScreen> {
  final UserController _userController = Get.put(UserController());
  Future<ActiveExamList> exams;
  var id;

  String _token;

  _ActiveOnlineExamScreenState({this.id});
  String schoolId;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records.first;
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = id != null ? id : value;
        exams = getAllActiveExam(
            id, _userController.studentRecord.value.records.first.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Active Exam'),
      backgroundColor: Colors.white,
      body: getExamList(),
    );
  }

  Widget getExamList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentRecordWidget(
            onTap: (Record record) async {
              _userController.selectedRecord.value = record;
              setState(() {
                exams = getAllActiveExam(id, record.id);
              });
            },
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: FutureBuilder<ActiveExamList>(
              future: exams,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data.activeExams.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.activeExams.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ActiveOnlineExamRow(
                              snapshot.data.activeExams[index]);
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
        ],
      ),
    );
  }

  Future<ActiveExamList> getAllActiveExam(var id, int recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentOnlineActiveExam(id, recordId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ActiveExamList.fromJson(jsonData['data']['online_exams']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
