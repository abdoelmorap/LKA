import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Routine.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/server/LogoutService.dart';
import 'package:infixedu/utils/widget/RoutineRowWidget.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class DBStudentRoutine extends StatefulWidget {
  String? id;

  DBStudentRoutine({this.id});

  @override
  State<DBStudentRoutine> createState() => _DBStudentRoutineState();
}

class _DBStudentRoutineState extends State<DBStudentRoutine> {
  final UserController _userController = Get.put(UserController());
  List<String> weeks = AppFunction.weeks;
  var _token;
  Future<Routine>? routine;

  Future<Routine> getRoutine(int? recordId) async {
    try {
      final response = await http.get(
        Uri.parse(InfixApi.routineView(
          widget.id,
          "student",
          recordId: recordId,
        )),
        headers: Utils.setHeader(
          _token.toString(),
        ),
      );
      if (response.statusCode == 200) {
        var data = routineFromJson(response.body);
        return data;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void didChangeDependencies() async {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records!.first;
    await Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        routine =
            getRoutine(_userController.studentRecord.value.records!.first.id);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              color: Color(0xFF93CFC4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 25.w,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Routine".tr,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {
                    Get.dialog(LogoutService().logoutDialog());
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Padding(
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
                      _userController.studentRecord.value.records![recordIndex];
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      _userController.selectedRecord.value = record;
                      setState(
                        () {
                          routine = getRoutine(record.id);
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
                                  Color(0xFF90DCCE),
                                  Color(0xFF93CFC4),
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
                        style: Get.textTheme.subtitle1!.copyWith(
                          fontSize: 14,
                          color: _userController.selectedRecord.value == record
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _userController.studentRecord.value.records!.length,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<Routine>(
                future: routine,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.classRoutines!.length > 0) {
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            shrinkWrap: true,
                            itemCount: weeks.length,
                            itemBuilder: (context, index) {
                              List<ClassRoutine> classRoutines = snapshot
                                  .data!.classRoutines!
                                  .where(
                                      (element) => element.day == weeks[index])
                                  .toList();

                              return classRoutines.length == 0
                                  ? SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(weeks[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith()),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Text('Time'.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text('Subject'.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text('Room'.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith()),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: classRoutines.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, rowIndex) {
                                            return RoutineRowDesign(
                                              classRoutines[rowIndex]
                                                      .startTime! +
                                                  '-' +
                                                  classRoutines[rowIndex]
                                                      .endTime!,
                                              classRoutines[rowIndex].subject,
                                              classRoutines[rowIndex].room,
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
                        return SizedBox.shrink();
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
      ),
    );
  }
}
