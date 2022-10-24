// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Classes.dart';
import 'package:infixedu/utils/model/Section.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'attendance/AttendanceStudentList.dart';

class StudentAttendanceHome extends StatefulWidget {
  @override
  _StudentAttendanceHomeState createState() => _StudentAttendanceHomeState();
}

class _StudentAttendanceHomeState extends State<StudentAttendanceHome> {
  String _id;
  dynamic classId;
  dynamic sectionId;
  String _selectedClass;
  String _selectedSection;
  Future classes;
  Future<SectionList> sections;
  DateTime date;
  String day, year, month;
  String url;
  String _selectedDate;

  String maxDateTime;
  String minDateTime = '2019-01-01';
  String _format;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _token;
  String rule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    date = DateTime.now();
    maxDateTime = DateTime.now().toLocal().toString();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          _id = value;
          Utils.getStringValue('rule').then((ruleValue) {
            setState(() {
              rule = ruleValue;
              year = '${date.year}';
              month = getAbsoluteDate(date.month);
              day = getAbsoluteDate(date.day);
              classes = getAllClass(int.parse(_id));
              classes.then((value) {
                _selectedClass = value.classes[0].name;
                classId = value.classes[0].id;
                sections = getAllSection(int.parse(_id), classId);
                sections.then((sectionValue) {
                  _selectedSection = sectionValue.sections[0].name;
                  sectionId = sectionValue.sections[0].id;
                  url =
                      InfixApi.getStudentByClassAndSection(classId, sectionId);
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Search Attendance',
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    getClassDropdown(snapshot.data.classes),
                    FutureBuilder<SectionList>(
                      future: sections,
                      builder: (context, secSnap) {
                        if (secSnap.hasData) {
                          return getSectionDropdown(secSnap.data.sections);
                        } else {
                          return Center(child: CupertinoActivityIndicator());
                        }
                      },
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: Padding(
                    //           padding:
                    //               const EdgeInsets.only(left: 8.0, top: 8.0),
                    //           child: Text(
                    //             '$year - $month - $day',
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .headline4
                    //                 .copyWith(fontSize: 15.0),
                    //           ),
                    //         ),
                    //       ),
                    //       Icon(
                    //         Icons.calendar_today,
                    //         color: Colors.black12,
                    //         size: 20.0,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    InkWell(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          pickerTheme: DateTimePickerTheme(
                            confirm: Text('Done',
                                style: TextStyle(color: Colors.red)),
                            cancel: Text('cancel',
                                style: TextStyle(color: Colors.cyan)),
                          ),
                          minDateTime: DateTime.parse(minDateTime),
                          maxDateTime: DateTime.parse(maxDateTime),
                          initialDateTime: date,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (dateTime, List<int> index) {
                            setState(() {
                              date = dateTime;
                              _selectedDate =
                                  '${date.year}-${getAbsoluteDate(date.month)}-${getAbsoluteDate(date.day)}';
                            });
                          },
                          onConfirm: (dateTime, List<int> index) {
                            setState(() {
                              date = dateTime;
                              _selectedDate =
                                  '${date.year}-${getAbsoluteDate(date.month)}-${getAbsoluteDate(date.day)}';
                            });
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Text(
                                  _selectedDate == null
                                      ? "$year-$month-$day"
                                      : _selectedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(12)),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color:
                                  Theme.of(context).textTheme.subtitle1.color,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: Utils.gradientBtnDecoration,
            child: Text(
              "Search".tr,
              style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.white, fontSize: ScreenUtil().setSp(14)),
            ),
          ),
        ),
        onTap: () {
          var passedDate =
              _selectedDate == null ? "$year-$month-$day" : _selectedDate;
          Navigator.push(
              context,
              ScaleRoute(
                  page: StudentListAttendance(
                classCode: classId,
                sectionCode: sectionId,
                url: url,
                date: passedDate,
                token: _token,
              )));
        },
      ),
    );
  }

  Widget getClassDropdown(List classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child:
                  Text(item.name, style: Theme.of(context).textTheme.headline4),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(fontSize: ScreenUtil().setSp(15)),
        onChanged: (value) {
          setState(() {
            _selectedClass = value;

            classId = getCode(classes, value);

            sections = getAllSection(int.parse(_id), classId);
            sections.then((sectionValue) {
              _selectedSection = sectionValue.sections[0].name;
              sectionId = sectionValue.sections[0].id;
              url = InfixApi.getStudentByClassAndSection(classId, sectionId);
            });
          });
        },
        value: _selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sectionlist) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sectionlist.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child:
                  Text(item.name, style: Theme.of(context).textTheme.headline4),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(fontSize: ScreenUtil().setSp(15)),
        onChanged: (value) {
          setState(() {
            _selectedSection = value;

            sectionId = getCode(sectionlist, value);

            url = InfixApi.getStudentByClassAndSection(classId, sectionId);

            debugPrint('User select section $sectionId');
          });
        },
        value: _selectedSection,
      ),
    );
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future getAllClass(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getClassById(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (rule == "1" || rule == "5") {
        return AdminClassList.fromJson(jsonData['data']['teacher_classes']);
      } else {
        return ClassList.fromJson(jsonData['data']['teacher_classes']);
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SectionList> getAllSection(int id, int classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
