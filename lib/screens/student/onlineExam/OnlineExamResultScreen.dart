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
import 'package:infixedu/utils/model/ONlineExamResult.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/widget/OnlineExamResultRow.dart';

// ignore: must_be_immutable
class OnlineExamResultScreen extends StatefulWidget {
  var id;

  OnlineExamResultScreen({this.id});

  @override
  _OnlineExamResultScreenState createState() => _OnlineExamResultScreenState();
}

class _OnlineExamResultScreenState extends State<OnlineExamResultScreen> {
  final UserController _userController = Get.put(UserController());
  Future<OnlineExamResultList> results;
  var id;
  dynamic code;
  var _selected;
  Future<OnlineExamNameList> exams;
  String _token;

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
        exams = getAllOnlineExam(
            id, _userController.studentRecord.value.records.first.id);
        exams.then((val) {
          _selected = val.names.length != 0 ? val.names[0].title : '';
          code = val.names.length != 0 ? val.names[0].id : 0;
          results = getAllOnlineExamResult(
              id, code, _userController.studentRecord.value.records.first.id);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Result'),
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
                    exams = getAllOnlineExam(id, record.id);
                    exams.then((val) {
                      _selected =
                          val.names.length != 0 ? val.names[0].title : '';
                      code = val.names.length != 0 ? val.names[0].id : 0;
                      results = getAllOnlineExamResult(id, code, record.id);
                    });
                  },
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: FutureBuilder<OnlineExamNameList>(
                future: exams,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data.names.length > 0) {
                      return Column(
                        children: <Widget>[
                          getDropdown(snapshot.data.names),
                          SizedBox(
                            height: 15.0,
                          ),
                          Expanded(child: getExamResultList())
                        ],
                      );
                    } else {
                      return Utils.noDataWidget();
                    }
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDropdown(List<OnlineExamName> names) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: names.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Text(
              item.title,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selected = value;

            code = getExamCode(names, value);
            results = getAllOnlineExamResult(
                id, code, _userController.selectedRecord.value.id);

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<OnlineExamResultList> getAllOnlineExamResult(
      var id, dynamic code, int recordId) async {
    final response = await http.get(
        Uri.parse(
            InfixApi.getStudentOnlineActiveExamResult(id, code, recordId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamResultList.fromJson(jsonData['data']['exam_result']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<OnlineExamNameList> getAllOnlineExam(var id, int recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentOnlineActiveExamName(id, recordId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamNameList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  dynamic getExamCode(List<OnlineExamName> names, String title) {
    dynamic code;
    for (OnlineExamName name in names) {
      if (name.title == title) {
        code = name.id;
        break;
      }
    }
    return code;
  }

  Widget getExamResultList() {
    return FutureBuilder<OnlineExamResultList>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.results.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.results.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OnlineExamResultRow(snapshot.data.results[index]);
              },
            );
          } else {
            return Utils.noDataWidget();
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}
