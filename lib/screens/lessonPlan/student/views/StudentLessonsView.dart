import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/lessonPlan/student/model/LessonPlan.dart';
import 'package:infixedu/screens/lessonPlan/student/model/LessonPlanDetails.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentLessonsView extends StatefulWidget {
  final String id;
  StudentLessonsView(this.id);
  @override
  State<StudentLessonsView> createState() => _StudentLessonsViewState();
}

class _StudentLessonsViewState extends State<StudentLessonsView> {
  final UserController _userController = Get.put(UserController());

  Future<LessonPlan> lessonPlan;
  Future<List<PlanDetails>> planDetails;

  String selectedWeek = "";

  Future<LessonPlan> getLessonPlan(int recordId, studentId) async {
    try {
      final response = await http.get(
        Uri.parse(InfixApi.studentLessonPlan + "/${widget.id}/$recordId"),
        headers: Utils.setHeader(
          _userController.token.value.toString(),
        ),
      );
      if (response.statusCode == 200) {
        var data = lessonPlanFromJson(response.body);
        return data;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PlanDetails>> getLessonByDay(
      int recordId, studentId, date, dayId) async {
    try {
      final response = await http.get(
        Uri.parse(InfixApi.studentLessonPlanByDate +
            "/${widget.id}/$recordId/$date/$dayId"),
        headers: Utils.setHeader(
          _userController.token.value.toString(),
        ),
      );
      if (response.statusCode == 200) {
        var data = planDetailsFromJson(response.body);
        return data;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<LessonPlan> getPreviousWeek(int recordId, studentId, startDate) async {
    try {
      final response = await http.get(
        Uri.parse(InfixApi.studentLessonPreviousWeek +
            "/${widget.id}/$recordId/$startDate"),
        headers: Utils.setHeader(
          _userController.token.value.toString(),
        ),
      );
      if (response.statusCode == 200) {
        var data = lessonPlanFromJson(response.body);
        return data;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<LessonPlan> getNextWeek(int recordId, studentId, endDate) async {
    try {
      final response = await http.get(
        Uri.parse(InfixApi.studentLessonNextWeek +
            "/${widget.id}/$recordId/$endDate"),
        headers: Utils.setHeader(
          _userController.token.value.toString(),
        ),
      );
      if (response.statusCode == 200) {
        var data = lessonPlanFromJson(response.body);
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
        _userController.studentRecord.value.records.first;
    await Utils.getStringValue('token').then((value) {
      lessonPlan = getLessonPlan(
          _userController.studentRecord.value.records.first.id, widget.id);

      lessonPlan.then((value) {
        setState(() {
          selectedWeek = value.weeks.first.name;
          planDetails = getLessonByDay(
              _userController.studentRecord.value.records.first.id,
              widget.id,
              value.weeks.first.date,
              value.weeks.first.id);
        });
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: "Lesson Plan"),
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
                    lessonPlan = getLessonPlan(
                        _userController.selectedRecord.value.id, widget.id);

                    lessonPlan.then((value) {
                      setState(() {
                        selectedWeek = value.weeks.first.name;
                        planDetails = getLessonByDay(
                            _userController.selectedRecord.value.id,
                            widget.id,
                            value.weeks.first.date,
                            value.weeks.first.id);
                      });
                    });
                  },
                );
              },
            ),
            FutureBuilder<LessonPlan>(
              future: lessonPlan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator()),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data.weeks.length > 0) {
                      return Builder(builder: (context) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print(snapshot.data.weeks.first.date);

                                    lessonPlan = getPreviousWeek(
                                        _userController.selectedRecord.value.id,
                                        widget.id,
                                        snapshot.data.weeks.first.date);

                                    lessonPlan.then((value) {
                                      setState(() {
                                        selectedWeek = value.weeks.first.name;
                                        planDetails = getLessonByDay(
                                            _userController
                                                .selectedRecord.value.id,
                                            widget.id,
                                            value.weeks.first.date,
                                            value.weeks.first.id);
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.deepPurple,
                                    size: 16,
                                  ),
                                ),
                                Text(
                                  "Week ${snapshot.data.thisWeek}",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    print(snapshot.data.weeks.last.date);

                                    lessonPlan = getNextWeek(
                                        _userController.selectedRecord.value.id,
                                        widget.id,
                                        snapshot.data.weeks.last.date);

                                    lessonPlan.then((value) {
                                      setState(() {
                                        selectedWeek = value.weeks.first.name;
                                        planDetails = getLessonByDay(
                                            _userController
                                                .selectedRecord.value.id,
                                            widget.id,
                                            value.weeks.first.date,
                                            value.weeks.first.id);
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.deepPurple,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 50,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  Week week = snapshot.data.weeks[index];

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedWeek = week.name;

                                        planDetails = getLessonByDay(
                                            _userController
                                                .selectedRecord.value.id,
                                            widget.id,
                                            week.date,
                                            week.id);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: selectedWeek == week.name
                                            ? Border(
                                                bottom: BorderSide(
                                                    width: selectedWeek ==
                                                            week.name
                                                        ? 1.0
                                                        : 0,
                                                    color:
                                                        Colors.purple.shade900),
                                              )
                                            : null,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(week.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          Text(
                                              DateFormat.yMMMd()
                                                  .format(
                                                      DateTime.parse(week.date))
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 20,
                                  );
                                },
                                itemCount: snapshot.data.weeks.length,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FutureBuilder<List<PlanDetails>>(
                                future: planDetails,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.length > 0) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text('Time'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                ),
                                                Expanded(
                                                  child: Text('Subject'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                ),
                                                Expanded(
                                                  child: Text('Room'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                ),
                                                Expanded(
                                                  child: Text('Teacher'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                ),
                                                Expanded(
                                                  child: Text('Action'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.separated(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                            itemBuilder: (context, rowIndex) {
                                              PlanDetails plan =
                                                  snapshot.data[rowIndex];
                                              return InkWell(
                                                onTap: () {
                                                  if (plan.plan != null) {
                                                    showAlertDialog(
                                                        context, plan);
                                                  }
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                          '${plan.startTime} - ${plan.endTime}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          '${plan.subject}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          '${plan.room}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          '${plan.teacher}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4),
                                                    ),
                                                    Expanded(
                                                      child: plan.plan != null
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'View'.tr,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline4),
                                                            )
                                                          : Text('',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Utils.noDataWidget();
                                    }
                                  }
                                  return CupertinoActivityIndicator();
                                }),
                          ],
                        );
                      });
                    } else {
                      return SizedBox.shrink();
                    }
                  } else {
                    return Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator()),
                    );
                  }
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, PlanDetails plan) {
    List<String> topicNames = [];
    List<String> subTopicNames = [];
    List<String> ytLinks = [];

    plan.plan.topics.forEach((element) {
      topicNames.add(element.topicName.topicTitle);
      subTopicNames.add(element.subTopicTitle);
    });

    plan.plan.lectureYouubeLink.split(',').forEach((element) {
      ytLinks.add(element);
    });
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Subject".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "${plan.subject}",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Date".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "${DateFormat('EEE, MMM dd').format(plan.plan.lessonDate)}",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Lesson".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "${plan.plan.lessonName.lessonTitle}",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Topics".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Wrap(
                                  children: List.generate(
                                      topicNames.length,
                                      (index) => Text(
                                            "${topicNames[index]}" +
                                                "${topicNames.length == topicNames.length - 1 ? "" : ","}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ))),
                            ),
                          ),
                        ],
                      ),
                      plan.subTopicEnabled
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox.shrink(),
                      plan.subTopicEnabled
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    "Subtopic".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  ":",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Wrap(
                                        children: List.generate(
                                            topicNames.length,
                                            (index) => Text(
                                                  "${subTopicNames[index]}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ))),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Lecture Youtube link".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: ytLinks.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, yt) {
                                    return SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemBuilder: ((context, ytIndex) {
                                    return GestureDetector(
                                      onTap: () async {
                                        final url = "${ytLinks[ytIndex]}";
                                        print(url);
                                        // ignore: deprecated_member_use
                                        if (await canLaunch(url)) {
                                          // ignore: deprecated_member_use
                                          await launch(url);
                                        } else {
                                          CustomSnackBar().snackBarWarning(
                                              "Unable to open");
                                          throw 'Unable to open url : $url';
                                        }
                                      },
                                      child: Container(
                                        child: Text(
                                          "${++ytIndex}" +
                                              ") ${ytLinks[--ytIndex]}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(color: Colors.blue),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (plan.plan.attachment == null ||
                              plan.plan.attachment == "")
                          ? SizedBox.shrink()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    "Document".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  ":",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      print(plan.plan.attachment);
                                      final url =
                                          "${AppConfig.domainName}/${plan.plan.attachment}";
                                      print(url);
                                      // ignore: deprecated_member_use
                                      if (await canLaunch(url)) {
                                        // ignore: deprecated_member_use
                                        await launch(url);
                                      } else {
                                        CustomSnackBar()
                                            .snackBarWarning("Unable to open");
                                        throw 'Unable to open url : $url';
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        "Download",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Note".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "${plan.plan.note ?? ""}",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
