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
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/ClassExam.dart';
import 'package:infixedu/utils/model/ExamRoutineReport.dart';
import 'package:infixedu/utils/model/ExamSchedule.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/widget/ClassExamResultRow.dart';

// ignore: must_be_immutable
class ClassExamResultScreen extends StatefulWidget {
  var id;

  ClassExamResultScreen({this.id});

  @override
  _ClassExamResultScreenState createState() => _ClassExamResultScreenState();
}

class _ClassExamResultScreenState extends State<ClassExamResultScreen> {
  final UserController _userController = Get.put(UserController());
  Future<ClassExamResultList> results;
  var id;
  dynamic examId;
  var _selected;
  String _token;

  Future<ExamSchedule> examSchedule;
  int examTypeId;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records.first;
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = widget.id != null ? widget.id : value;

        examSchedule = getStudentExamSchedule(id);

        examSchedule.then((val) {
          setState(() {
            _selected = val.examTypes.length != 0 ? val.examTypes[0].title : '';
            examTypeId = val.examTypes.length != 0 ? val.examTypes[0].id : 0;
            examId = getExamCode(val.examTypes, val.examTypes[0].title);
            results = getAllClassExamResult(
              id,
              examTypeId,
              _userController.studentRecord.value.records.first.id,
            );
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Exam Result'),
      backgroundColor: Colors.white,
      body: FutureBuilder<ExamSchedule>(
        future: examSchedule,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.examTypes.length > 0) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data.examTypes),
                  Expanded(child: getExamResultList())
                ],
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

  Widget getDropdown(List<ExamType> exams) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: exams.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.subtitle1.copyWith(),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _userController.selectedRecord.value =
                _userController.studentRecord.value.records.first;
            _selected = value;

            examId = getExamCode(exams, value);
            results = getAllClassExamResult(
              id,
              examId,
              _userController.studentRecord.value.records.first.id,
            );

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<ClassExamResultList> getAllClassExamResult(
      var id, dynamic examId, int recordId) async {
    print(Uri.parse(InfixApi.getStudentClassExamResult(id, examId, recordId)));
    final response = await http.get(
        Uri.parse(InfixApi.getStudentClassExamResult(id, examId, recordId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ClassExamResultList.fromJson(jsonData['data']['exam_result']);
    } else {
      throw Exception('Failed to load');
    }
  }

  int getExamCode(List<ExamType> exams, String title) {
    int code;

    for (ExamType exam in exams) {
      if (exam.title == title) {
        code = exam.id;
        break;
      }
    }
    return code;
  }

  Future<ExamSchedule> getStudentExamSchedule(var id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentExamSchedule(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      return examScheduleFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Widget getExamResultList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
              itemBuilder: (context, recordIndex) {
                Record record =
                    _userController.studentRecord.value.records[recordIndex];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    _userController.selectedRecord.value = record;
                    setState(
                      () {
                        results = getAllClassExamResult(
                          id,
                          examId,
                          record.id,
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: _userController.selectedRecord.value == record
                            ? Colors.transparent
                            : Colors.grey,
                      ),
                      gradient: _userController.selectedRecord.value == record
                          ? LinearGradient(
                              colors: [
                                Color(0xff7C32FF),
                                Color(0xffC738D8),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                    ),
                    child: Text(
                      "${record.className} (${record.sectionName})",
                      style: Get.textTheme.subtitle1.copyWith(
                        fontSize: 14,
                        color: _userController.selectedRecord.value == record
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
              itemCount: _userController.studentRecord.value.records.length,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<ClassExamResultList>(
              future: results,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data.results.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.results.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ClassExamResultRow(
                              snapshot.data.results[index]);
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
    );
  }
}
