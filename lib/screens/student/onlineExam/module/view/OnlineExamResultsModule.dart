import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/student/onlineExam/module/model/OnlineExamResultModel.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:http/http.dart' as http;

class OnlineExamResults extends StatefulWidget {
  final id;
  OnlineExamResults({this.id});

  @override
  _OnlineExamResultsState createState() => _OnlineExamResultsState(id: id);
}

class _OnlineExamResultsState extends State<OnlineExamResults> {
  var id;
  _OnlineExamResultsState({this.id});

  final UserController _userController = Get.put(UserController());

  Future<OnlineExamResultModel> exams;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records.first;

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
      appBar: CustomAppBarWidget(title: 'Exam Result'),
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
                    setState(() {
                      exams = getAllActiveExam(id, record.id);
                    });
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
            height: 15,
          ),
          Expanded(
            child: FutureBuilder<OnlineExamResultModel>(
              future: exams,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data.data.studentExams.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.data.studentExams.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ActiveOnlineExamRow(
                            exam: snapshot.data.data.studentExams[index],
                          );
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

  Future<OnlineExamResultModel> getAllActiveExam(var id, int recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getOnlineExamResultModule(id, recordId)),
        headers: Utils.setHeader(_userController.token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamResultModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }
}

class ActiveOnlineExamRow extends StatefulWidget {
  final StudentExam exam;

  ActiveOnlineExamRow({
    this.exam,
  });

  @override
  State<ActiveOnlineExamRow> createState() => _ActiveOnlineExamRowState();
}

class _ActiveOnlineExamRowState extends State<ActiveOnlineExamRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.exam.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: ScreenUtil().setSp(15.0)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Title'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.exam.title,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Start'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${widget.exam.startDate}" +
                              " (${widget.exam.startTime})",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'End'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${widget.exam.endDate}" +
                              " (${widget.exam.endTime})",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Status'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        getStatus(context, widget.exam.result),
                      ],
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget getStatus(BuildContext context, String status) {
    if (status == "Pass") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Passed'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.red.shade500),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Failed'.tr,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      );
    }
  }
}
