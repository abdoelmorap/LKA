// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/TeacherMyRoutine.dart';

import 'package:infixedu/utils/widget/RoutineRowWidget.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TeacherMyRoutineScreen extends StatefulWidget {
  @override
  State<TeacherMyRoutineScreen> createState() => _TeacherMyRoutineScreenState();
}

class _TeacherMyRoutineScreenState extends State<TeacherMyRoutineScreen> {
  List<String> weeks = AppFunction.weeks;

  var _token;

  var _id;

  Future<TeacherRoutine> getRoutine() async {
    TeacherRoutine data;
    await Utils.getStringValue('id').then((id) {
      _id = id;
    }).then((value) async {
      await Utils.getStringValue('token').then((token) {
        _token = token;
      });
    }).then((value) async {
      final response = await http.get(
          Uri.parse(InfixApi.routineView(_id, "teacher", mine: true)),
          headers: Utils.setHeader(_token.toString()));
      if (response.statusCode == 200) {
        data = teacherRoutineFromJson(response.body);
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    });
    return data;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: "My Routine",
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
            child: FutureBuilder<TeacherRoutine>(
              future: getRoutine(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.classRoutines.length > 0) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: weeks.length,
                        itemBuilder: (context, index) {
                          List<ClassRoutine> classRoutines = snapshot
                              .data.classRoutines
                              .where((element) => element.day == weeks[index])
                              .toList();

                          return classRoutines.length == 0
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(weeks[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith()),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Text('Time'.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .copyWith()),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text('Class'.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .copyWith()),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text('Room'.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .copyWith()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: classRoutines.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, rowIndex) {
                                        return RoutineRowDesignTeacher(
                                          classRoutines[rowIndex].startTime +
                                              '-' +
                                              classRoutines[rowIndex].endTime,
                                          classRoutines[rowIndex].subject,
                                          classRoutines[rowIndex].room,
                                          classRoutineClass:
                                              classRoutines[rowIndex]
                                                  .classRoutineClass,
                                          section:
                                              classRoutines[rowIndex].section,
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 0.5,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF415094),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                        });
                  } else {
                    return Text("");
                  }
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
