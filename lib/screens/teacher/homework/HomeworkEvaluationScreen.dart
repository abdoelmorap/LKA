// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/screens/teacher/homework/EvaluateScreen.dart';
import 'package:infixedu/screens/teacher/homework/UploadedFilesView.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/HomeworkEvaluation.dart';
import 'package:infixedu/utils/widget/HomeWorkEvaluationDetailsRow.dart';

class HomeworkEvaluationScreen extends StatefulWidget {
  HomeworkEvaluationScreen({this.classId, this.sectionId, this.homeworkId});

  final dynamic classId;
  final dynamic sectionId;
  final dynamic homeworkId;

  @override
  _HomeworkEvaluationScreenState createState() =>
      _HomeworkEvaluationScreenState();
}

class _HomeworkEvaluationScreenState extends State<HomeworkEvaluationScreen> {
  Future<StudentEvaluationList> evaluations;
  Future<StudentHomeworkEvaluation> homeWorks;

  String _token;
  var totalMarks;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        evaluations = fetchEvaluationList(
            widget.classId, widget.sectionId, widget.homeworkId);
        homeWorks = fetchHomeworkDetails(
            widget.classId, widget.sectionId, widget.homeworkId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Homework Evaluation'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: FutureBuilder<StudentHomeworkEvaluation>(
                future: homeWorks,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot != null) {
                    return StatefulBuilder(builder: (context, state) {
                      state(() {
                        totalMarks = snapshot.data.marks;
                      });
                      return HomeWorkEvaluationDetailsRow(snapshot.data);
                    });
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
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
            ),
            Expanded(
              child: StreamBuilder<StudentEvaluationList>(
                stream: Stream.periodic((Duration(seconds: 5))).asyncMap(
                    (event) => fetchEvaluationList(
                        widget.classId, widget.sectionId, widget.homeworkId)),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Students',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(14),
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.studentEvaluation.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Name',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            SizedBox(height: 2.0),
                                            Text(
                                              snapshot
                                                          .data
                                                          .studentEvaluation[
                                                              index]
                                                          .studentName ==
                                                      null
                                                  ? 'N/A'
                                                  : snapshot
                                                      .data
                                                      .studentEvaluation[index]
                                                      .studentName,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            SizedBox(height: 10.0),
                                          ],
                                        ),
                                      ),
                                      snapshot.data.studentEvaluation[index]
                                                      .marks ==
                                                  null ||
                                              snapshot
                                                      .data
                                                      .studentEvaluation[index]
                                                      .marks ==
                                                  ""
                                          ? Expanded(
                                              child: Container(
                                                height: 35,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EvaluateScreen(
                                                                  totalMarks:
                                                                      totalMarks,
                                                                  marks: snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .marks,
                                                                  teacherComment: snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .teacherComments,
                                                                  status: snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .completeStatus,
                                                                  studentId: snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .studentId,
                                                                  homeworkId: snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .homeworkId,
                                                                  files: snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .file,
                                                                  studentName: snapshot
                                                                          .data
                                                                          .studentEvaluation[
                                                                              index]
                                                                          .studentName +
                                                                      '\'s Homework',
                                                                )));
                                                  },
                                                  child: Text(
                                                    'Evaluate',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14)),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Marks',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline4
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Text(
                                                          snapshot
                                                                          .data
                                                                          .studentEvaluation[
                                                                              index]
                                                                          .marks ==
                                                                      null ||
                                                                  snapshot
                                                                          .data
                                                                          .studentEvaluation[
                                                                              index]
                                                                          .marks ==
                                                                      ""
                                                              ? 'N/A'
                                                              : snapshot
                                                                  .data
                                                                  .studentEvaluation[
                                                                      index]
                                                                  .marks,
                                                          maxLines: 1,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                        ),
                                                        SizedBox(height: 10.0),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Comment',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline4
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Text(
                                                          snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .teacherComments ==
                                                                  null
                                                              ? 'N/A'
                                                              : snapshot
                                                                          .data
                                                                          .studentEvaluation[
                                                                              index]
                                                                          .teacherComments ==
                                                                      "NG"
                                                                  ? "Not Good"
                                                                  : "Good",
                                                          maxLines: 1,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                        ),
                                                        SizedBox(height: 10.0),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Status',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline4
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Text(
                                                          snapshot
                                                                      .data
                                                                      .studentEvaluation[
                                                                          index]
                                                                      .completeStatus ==
                                                                  null
                                                              ? 'N/A'
                                                              : snapshot
                                                                          .data
                                                                          .studentEvaluation[
                                                                              index]
                                                                          .completeStatus ==
                                                                      "C"
                                                                  ? "Completed"
                                                                  : "Not Complete",
                                                          maxLines: 1,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                        ),
                                                        SizedBox(height: 10.0),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Submitted Files: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            SizedBox(width: 2.0),
                                            snapshot
                                                        .data
                                                        .studentEvaluation[
                                                            index]
                                                        .file
                                                        .length ==
                                                    0
                                                ? Text(
                                                    'N/A',
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  )
                                                : Container(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UploadedFilesView(
                                                                          files: snapshot
                                                                              .data
                                                                              .studentEvaluation[index]
                                                                              .file,
                                                                          fileName:
                                                                              snapshot.data.studentEvaluation[index].studentName + '\'s attached file',
                                                                        )));
                                                      },
                                                      child: Text(
                                                        'View',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 0.5,
                                    margin:
                                        EdgeInsets.only(bottom: 5.0, top: 5.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          colors: [
                                            Colors.purple,
                                            Colors.deepPurple
                                          ]),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<StudentEvaluationList> fetchEvaluationList(
      int classId, int sectionId, int homeworkId) async {
    // print(InfixApi.homeworkEvaluationList(classId, sectionId, homeworkId));
    final response = await http.get(
        Uri.parse(
            InfixApi.homeworkEvaluationList(classId, sectionId, homeworkId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StudentEvaluationList.fromJson(
          jsonData['data']['student_homeworks']);
    } else {
      throw Exception('failed to load');
    }
  }

  Future<StudentHomeworkEvaluation> fetchHomeworkDetails(
      int classId, int sectionId, int homeworkId) async {
    print(InfixApi.homeworkEvaluationList(classId, sectionId, homeworkId));
    final response = await http.get(
        Uri.parse(
            InfixApi.homeworkEvaluationList(classId, sectionId, homeworkId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StudentHomeworkEvaluation.fromJson(
          jsonData['data']['homeworkDetails'][0]);
    } else {
      throw Exception('failed to load');
    }
  }
}
