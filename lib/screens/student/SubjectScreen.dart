// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/controller/user_controller.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/model/Subject.dart';
import 'package:infixedu/utils/widget/SubjectRowLayout.dart';

// ignore: must_be_immutable
class SubjectScreen extends StatefulWidget {
  String id;

  SubjectScreen({this.id});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final UserController _userController = Get.put(UserController());
  Future<SubjectList> subjects;
  String _token;
  String _id;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records.first;
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        _id = value;
        subjects = getAllSubject(
            widget.id != null ? int.parse(widget.id) : int.parse(value),
            _userController.studentRecord.value.records.first.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Subjects'),
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
                    subjects = getAllSubject(
                        widget.id != null
                            ? int.parse(widget.id)
                            : int.parse(_id),
                        record.id);
                  },
                );
              },
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Subject'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text('Teacher'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text(
                              'Type'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<SubjectList>(
                      future: subjects,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data.subjects.length > 0) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.subjects.length,
                                itemBuilder: (context, index) {
                                  return SubjectRowLayout(
                                      snapshot.data.subjects[index]);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<SubjectList> getAllSubject(dynamic id, int recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSubjectsUrl(id, recordId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SubjectList.fromJson(jsonData['data']['student_subjects']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
