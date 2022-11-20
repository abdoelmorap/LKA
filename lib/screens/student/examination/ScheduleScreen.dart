// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/ExamRoutineReport.dart';
import 'package:infixedu/utils/model/ExamSchedule.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ScheduleScreen extends StatefulWidget {
  var id;

  ScheduleScreen({this.id});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(id: id);
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var _selected;

  Future<ExamSchedule> examSchedule;
  Future<ExamRoutineReport> examRoutine;
  int examTypeId;
  var id;
  dynamic examId;

  String _token;

  _ScheduleScreenState({this.id});

  @override
  void initState() {
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
        id = id != null ? id : value;
        examSchedule = getStudentExamSchedule(id);

        examSchedule.then((val) {
          _selected = val.examTypes.length != 0 ? val.examTypes[0].title : '';
          examTypeId = val.examTypes.length != 0 ? val.examTypes[0].id : 0;
          examRoutine = getExamRoutineReport(examTypeId);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Schedule'),
      backgroundColor: Colors.white,
      body: FutureBuilder<ExamSchedule>(
        future: examSchedule,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.examTypes.length > 0) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data.examTypes),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(child: getExamList())
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
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
            _selected = value;

            examId = getExamCode(exams, value);
            examRoutine = getExamRoutineReport(examId);

            getExamList();
          });
        },
        value: _selected,
      ),
    );
  }

  Widget getExamList() {
    return FutureBuilder<ExamRoutineReport>(
      future: examRoutine,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.examRoutines.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                List<ExamRoutine> value =
                    snapshot.data.examRoutines.values.elementAt(index);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Date'.tr + ': ',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DateFormat.yMMMEd().format(value[0].date),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    Column(
                      children: List.generate(value.length, (scheduleIndex) {
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Subject'.tr + ': ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                ),
                                Expanded(
                                  child: Text(
                                    '${value[scheduleIndex].subject}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Time'.tr + ': ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                ),
                                Expanded(
                                  child: Text(
                                    '${value[scheduleIndex].startTime} - ${value[scheduleIndex].endTime}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Room Number'.tr,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        value[scheduleIndex].room,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Class (Section)'.tr,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "${value[scheduleIndex].className} (${value[scheduleIndex].section})",
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Teacher'.tr,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        value[scheduleIndex].teacher,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                    Divider(
                      height: 20,
                    ),
                  ],
                );
              },
            );
          } else {
            return Utils.noDataWidget();
          }
        }
      },
    );
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
      // var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return examScheduleFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<ExamRoutineReport> getExamRoutineReport(id) async {
    print("Exam type Id $id");
    final response =
        await http.post(Uri.parse(InfixApi.getStudentRoutineReport),
            headers: Utils.setHeader(_token.toString()),
            body: jsonEncode({
              'exam': id,
            }));
    if (response.statusCode == 200) {
      return examRoutineReportFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
}
