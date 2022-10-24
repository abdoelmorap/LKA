// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/dailyreport.dart';

class DailyReportScreen extends StatefulWidget {
  @override
  _DailyReportScreenState createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  Future<DailyReportModel> dailyReport;
  DateTime mTimeofDay;
  String _token;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
    })
      ..then((value) {
        dailyReport = getDailyReport();
      });
    mTimeofDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(title: 'DailyReport'),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () {
                      mTimeofDay = mTimeofDay.add(Duration(days: -1));
                      dailyReport = getSelectedDayData(mTimeofDay);
                      setState(() {});
                    },
                  ),
                  Text(
                    "${mTimeofDay.toLocal().day}/${mTimeofDay.toLocal().month}/${mTimeofDay.toLocal().year}",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  GestureDetector(
                    child: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      mTimeofDay = mTimeofDay.add(Duration(days: 1));
                      dailyReport = getSelectedDayData(mTimeofDay);
                      setState(() {});
                    },
                  ),
                ],
              ),
              color: Color(0xFF93CFC4),
            ),
            Expanded(
              child: FutureBuilder<DailyReportModel>(
                future: dailyReport,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      child: Text(
                        "Not Available",
                        style: TextStyle(fontSize: 45),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return Container(
                      child:
                          // Text(snapshot.data.fullName),
                          ListView(
                        children: [
                          rowItem(
                              0xfff39eaa,
                              "MOOD",
                              [
                                "AfterNoon",
                                "Morning",
                                "Noon",
                              ],
                              [
                                snapshot.data.afternoon,
                                snapshot.data.morning,
                                snapshot.data.noon,
                              ],
                              [
                                "assets/images/happy.png",
                                "assets/images/sad.png",
                                "assets/images/wizzy.png"
                              ],
                              60),
                          rowItem(
                              0xff93CFC4,
                              "FOOD",
                              [
                                "Breakfast",
                                "Lunch",
                                "Snack",
                              ],
                              [
                                snapshot.data.breakfast,
                                snapshot.data.lunch,
                                snapshot.data.snack,
                              ],
                              [
                                "assets/images/emptydish.jpeg",
                                "assets/images/halfdish.webp",
                                "assets/images/fulldish.jpg"
                              ],
                              60),
                          rowItem(
                              0xffffd402,
                              "Drink",
                              [
                                "Water",
                                "Milk",
                                "Juice",
                              ],
                              [
                                snapshot.data.water,
                                snapshot.data.milk,
                                snapshot.data.juice,
                              ],
                              [
                                "assets/images/empty_water.jpeg",
                                "assets/images/halfwater.jpeg",
                                "assets/images/full_water.jpeg",
                              ],
                              25),
                          singelItem(
                              0xfff39eaa,
                              "Hygiene",
                              "X " + snapshot.data.hygiene.toString(),
                              "assets/images/shield.png",
                              70),
                          singelItem(
                              0xff93CFC4,
                              "Temperature",
                              snapshot.data.temperature.toString(),
                              "assets/images/Temperature.png",
                              70),
                          singelItem(
                              0xffffd402,
                              "Sleep",
                              snapshot.data.sleep.toString() + " Minutes",
                              "assets/images/sleep.png",
                              70),
                          singelItemComent(
                              0xfff39eaa,
                              "Comment",
                              snapshot.data.comment.toString(),
                              "assets/images/comment.png",
                              70),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget rowItem(int color, String title, List<String> titles,
      List<int> itemStatus, List<String> itemsImages, double width) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Color(color),
        width: 5,
      ))),
      child: Column(
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            height: 35,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(100.0, 0, 100, 0),
          ),
          SizedBox(
            width: 5,
          ),
          Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    Text(titles[0]),
                    itemStatus[0] == 1
                        ? Image.asset(
                            itemsImages[0],
                            width: width,
                          )
                        : itemStatus[0] == 2
                            ? Image.asset(
                                itemsImages[1],
                                width: width,
                              )
                            : itemStatus[0] == 3
                                ? Image.asset(
                                    itemsImages[2],
                                    width: width,
                                  )
                                : Container(),
                  ],
                ),
                right: 0,
              ),
              Positioned(
                child: Column(
                  children: [
                    Text(titles[1]),
                    itemStatus[1] == 1
                        ? Image.asset(
                            itemsImages[0],
                            width: width,
                          )
                        : itemStatus[1] == 2
                            ? Image.asset(
                                itemsImages[1],
                                width: width,
                              )
                            : itemStatus[1] == 3
                                ? Image.asset(
                                    itemsImages[2],
                                    width: width,
                                  )
                                : Container(),
                  ],
                ),
                left: 0,
              ),
              Align(
                child: Column(
                  children: [
                    Text(titles[2]),
                    itemStatus[2] == 1
                        ? Image.asset(
                            itemsImages[0],
                            width: width,
                          )
                        : itemStatus[2] == 2
                            ? Image.asset(
                                itemsImages[1],
                                width: width,
                              )
                            : itemStatus[2] == 3
                                ? Image.asset(
                                    itemsImages[2],
                                    width: width,
                                  )
                                : Container(),
                  ],
                ),
                alignment: Alignment.center,
              )
            ],
          )
        ],
      ),
      height: 150,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget singelItem(int color, String title, String itemStatus,
      String itemsImages, double width) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Color(color),
        width: 5,
      ))),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            height: 35,
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  itemsImages,
                  width: width,
                ),
                Text(
                  "$itemStatus",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          )
        ],
      ),
      height: 150,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget singelItemComent(int color, String title, String itemStatus,
      String itemsImages, double width) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
          child: Container(
        margin: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
          color: Color(color),
          width: 5,
        ))),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                title,
                style: TextStyle(
                    color: Color(0xff93cfc4),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              height: 35,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 80 / 100,
                      child: Text(
                        "$itemStatus",
                        style: TextStyle(fontSize: 25),
                      ))
                ],
              ),
            )
          ],
        ),
        width: MediaQuery.of(context).size.width,
      ))
    ]);
  }

  Future<DailyReportModel> getSelectedDayData(DateTime mTimeofDay) async {
    var id = await Utils.getIntValue("studentId") ??
        await Utils.getIntValue("myStudentId");
    final response = await http.post(
        Uri.parse(InfixApi.getKidsStatusbyDay + "/$id"),
        headers: Utils.setHeader(_token.toString()),
        body: jsonEncode({
          "Date_Selected":
              "${mTimeofDay.month}/${mTimeofDay.day}/${mTimeofDay.year}"
        }));
    print("${mTimeofDay.month}/${mTimeofDay.day}/${mTimeofDay.year}" +
        response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData[0]);
      try {
        mTimeofDay =
            DateTime.parse(DailyReportModel.fromJson(jsonData.last).dateOfDay);

        return DailyReportModel.fromJson(jsonData.last);
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to load');
    }
  }

  Future<DailyReportModel> getDailyReport() async {
    var id = await Utils.getIntValue("studentId") ??
        await Utils.getIntValue("myStudentId");
    final response = await http.get(
        Uri.parse(InfixApi.studentDailyReport + "/$id"),
        headers: Utils.setHeader(_token.toString()));
    print(id);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData[0]);
      try {
        mTimeofDay =
            DateTime.parse(DailyReportModel.fromJson(jsonData.last).dateOfDay);

        return DailyReportModel.fromJson(jsonData.last);
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to load');
    }
  }
}
