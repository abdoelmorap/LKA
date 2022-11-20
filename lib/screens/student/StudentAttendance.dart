// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/controller/user_controller.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentAttendance.dart';
import 'package:infixedu/utils/model/StudentDetailsModel.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';

// ignore: must_be_immutable
class StudentAttendanceScreen extends StatefulWidget {
  dynamic id;
  String schoolId;
  var token;

  StudentAttendanceScreen({this.id, this.token, this.schoolId});

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState(id: id, token: token, schoolId: schoolId);
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final UserController _userController = Get.put(UserController());
  var id;
  String token;
  String schoolId;
  Future<StudentAttendanceList> attendances;

  _StudentAttendanceScreenState({this.id, this.token, this.schoolId});

  bool isLoading = false;
  @override
  void initState() {
    _userController.isLoading.value = true;
    Utils.getStringValue('token').then((value) {
      setState(() {
        token = value;
      });
    });

    super.initState();
  }

  StudentDetailsModel _studentDetails = StudentDetailsModel();

  Future<StudentDetailsModel> getProfile(id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getChildren(id.toString())),
        headers: id == null ? null : Utils.setHeader(token.toString()));
    if (response.statusCode == 200) {
      final studentDetails = studentDetailsFromJson(response.body);
      _studentDetails = studentDetails;
    } else {
      throw "error";
    }
    return _studentDetails;
  }

  @override
  void didChangeDependencies() async {
    await Utils.getStringValue('id').then((idValue) async {
      setState(() {
        id = int.parse(idValue);
      });
    });
    if (id != null) {
      await Utils.getStringValue('schoolId').then((value) {
        setState(() {
          schoolId = value;
        });
      }).then((value) async {
        await getProfile(id).then((value) async {
          _userController.studentId.value = value.studentData.userDetails.id;

          await _userController.getStudentRecord().then((value) {
            DateTime date = DateTime.now();
            attendances = getAllStudentAttendance(
                id,
                _userController.studentRecord.value.records.first.id,
                date.month,
                date.year,
                token,
                int.parse(schoolId));
          });
        });
      });
    } else {
      _userController.isLoading.value = false;
      await Utils.getStringValue('id').then((value) async {
        setState(() {
          id = int.parse(value);
        });
        await Utils.getStringValue('schoolId').then((schoolVal) {
          setState(() {
            schoolId = schoolVal;
          });
        }).then((value) {
          DateTime date = DateTime.now();
          attendances = getAllStudentAttendance(
              id,
              _userController.studentRecord.value.records.first.id,
              date.month,
              date.year,
              token,
              int.parse(schoolId));
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _currentDate;
    var _markedDateMap;

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Attendance'),
      backgroundColor: Colors.white,
      body: Opacity(
        opacity: isLoading ? 0.5 : 1.0,
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    if (_userController.isLoading.value) {
                      return SizedBox.shrink();
                    } else {
                      return StudentRecordWidget(
                        onTap: (Record record) async {
                          _userController.selectedRecord.value = record;
                          setState(
                            () {
                              DateTime date = DateTime.now();
                              attendances = getAllStudentAttendance(
                                  widget.id,
                                  _userController.selectedRecord.value.id,
                                  date.month,
                                  date.year,
                                  token,
                                  int.parse(schoolId));
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                Container(
                  height: Get.height * 0.5,
                  child: CalendarCarousel<Event>(
                      weekDayPadding: EdgeInsets.zero,
                      onDayPressed: (DateTime date, List<Event> events) {
                        this.setState(() => _currentDate = date);
                      },
                      onCalendarChanged: (DateTime date) {
                        setState(() {
                          attendances = getAllStudentAttendance(
                              widget.id,
                              _userController.selectedRecord.value.id,
                              date.month,
                              date.year,
                              token,
                              int.parse(schoolId));
                        });
                      },
                      weekendTextStyle: Theme.of(context).textTheme.headline6,
                      thisMonthDayBorderColor: Colors.grey,
                      daysTextStyle: Theme.of(context).textTheme.headline4,
                      showOnlyCurrentMonthDate: false,
                      headerTextStyle: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: ScreenUtil().setSp(15.0)),
                      weekdayTextStyle: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(
                              fontSize: ScreenUtil().setSp(15.0),
                              fontWeight: FontWeight.w500),
                      customDayBuilder: (
                        /// you can provide your own build function to make custom day containers
                        bool isSelectable,
                        int index,
                        bool isSelectedDay,
                        bool isToday,
                        bool isPrevMonthDay,
                        TextStyle textStyle,
                        bool isNextMonthDay,
                        bool isThisMonthDay,
                        DateTime day,
                      ) {
                        return FutureBuilder<StudentAttendanceList>(
                          future: attendances,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              //Utils.showToast(getAttendanceStatus(day.day, snapshot.data.attendances));

                              String status = getAttendanceStatus(
                                  day.day, snapshot.data.attendances);

                              if (isThisMonthDay) {
                                if (isToday) {
                                  return Center(
                                    child: Container(
                                      width: ScreenUtil().setWidth(50),
                                      height: ScreenUtil().setHeight(45),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(day.day.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                    color: Color(0xFF5F75EF),
                                                    fontSize: ScreenUtil()
                                                        .setSp(14.0),
                                                  )),
                                          SizedBox(
                                            width: 1.5,
                                          ),
                                          Container(
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: getStatusColor(status),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            day.day.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .copyWith(
                                                  color: Color(0xFF727FC8),
                                                  fontSize:
                                                      ScreenUtil().setSp(14.0),
                                                ),
                                          ),
                                          SizedBox(
                                            width: 1.5,
                                          ),
                                          Container(
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: getStatusColor(status),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(day.day.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(14.0),
                                                    color: isToday == true
                                                        ? Colors.white
                                                        : Colors.grey)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Center(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(day.day.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  color: Color(0xFF727FC8))),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                      weekFormat: false,
                      markedDatesMap: _markedDateMap,
                      selectedDateTime: _currentDate,
                      // daysHaveCircularBorder: true,
                      todayButtonColor: Colors.transparent,
                      todayBorderColor: Colors.transparent,
                      todayTextStyle: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      bottomDesign('Present'.tr, 'P', Colors.green),
                      bottomDesign('Absent'.tr, 'A', Colors.red),
                      bottomDesign('Late'.tr, 'L', Color(0xFFEDD200)),
                      bottomDesign('Halfday'.tr, 'H', Colors.purpleAccent),
                      bottomDesign('Holiday'.tr, 'F', Colors.deepPurpleAccent),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomDesign(String title, String titleVal, Color color) {
    return FutureBuilder<StudentAttendanceList>(
        future: attendances,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: <Widget>[
                Container(
                  height: 20.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                    child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.black45, fontWeight: FontWeight.w500),
                )),
                Text(getStatusCount(titleVal, snapshot.data.attendances),
                    style: Theme.of(context).textTheme.headline5),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Future<StudentAttendanceList> getAllStudentAttendance(dynamic id,
      int recordId, int month, int year, String token, int schoolId) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.parse(InfixApi.getStudentAttendence(id, recordId, month, year)),
        headers: Utils.setHeader(token));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      return StudentAttendanceList.fromJson(jsonData['data']['attendances']);
    } else {
      throw Exception('Failed to load');
    }
  }

  String getAttendanceStatus(int date, List<StudentAttendance> attendances) {
    return getStatus(0, attendances.length - 1, attendances, date);
  }

  String getStatus(
      int i, int j, List<StudentAttendance> attendances, int date) {
    String status;
    for (int a = i; a <= j; a++) {
      if (int.parse(AppFunction.getDay(attendances[a].date)) == date) {
        status = attendances[a].type;
      }
    }
    return status;
  }

  getStatusColor(String status) {
    switch (status) {
      case 'P':
        return Colors.green;
        break;
      case 'A':
        return Colors.red;
        break;
      case 'L':
        return Color(0xFFEDD200);
        break;
      case 'H':
        return Colors.purpleAccent;
        break;
      case 'F':
        return Colors.deepPurple;
        break;
      default:
        return Colors.transparent;
        break;
    }
  }

  String getStatusCount(String titleVal, List<StudentAttendance> attendances) {
    int count = 0;
    for (int i = 0; i < attendances.length; i++) {
      if (attendances[i].type == titleVal) {
        count = count + 1;
      }
    }
    return '$count ' + "days".tr;
  }
}
