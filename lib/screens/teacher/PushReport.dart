import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';

import 'package:http/http.dart' as http;
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/dailyreport.dart';

class PushReport extends StatefulWidget {
  final String? id;
  final String? name;

  const PushReport({Key? key, this.id, this.name}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PushReportState();
  }
}

class _PushReportState extends State<PushReport> {
  String? mood = "1";
  String? noon = "1";

  String? afterNoon = "1";

  String? Breakfast = "1";

  String? Lunch = "1";

  String? Snack = "1";

  String? water = "1";

  String? milk = "1";

  String? juice = "1";

  TextEditingController Hygiene = TextEditingController();

  TextEditingController Temperature = TextEditingController();

  TextEditingController Sleep = TextEditingController();

  TextEditingController Comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Send Student Report",
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              widget.name!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              "Mood",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("Morning"),
                      DropdownButton<String>(
                        value: mood,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(
                          color: Color(0xff93cfc4),
                        ),
                        underline: Container(
                          height: 2,
                          color: Color(0xff93cfc4),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            mood = value;
                          });
                        },
                        items: ["1", "2", "3"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value ==
                                    "1"
                                        ""
                                ? Image.asset(
                                    "assets/images/happy.png",
                                    width: 35,
                                  )
                                : value == "2"
                                    ? Image.asset(
                                        "assets/images/sad.png",
                                        width: 35,
                                      )
                                    : Image.asset(
                                        "assets/images/wizzy.png",
                                        width: 35,
                                      ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text("Noon"),
                    DropdownButton<String>(
                      value: noon,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xff93cfc4),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xff93cfc4),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          noon = value;
                        });
                      },
                      items: ["1", "2", "3"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: value == "1"
                                ? Image.asset(
                                    "assets/images/happy.png",
                                    width: 35,
                                  )
                                : value == "2"
                                    ? Image.asset(
                                        "assets/images/sad.png",
                                        width: 35,
                                      )
                                    : Image.asset(
                                        "assets/images/wizzy.png",
                                        width: 35,
                                      ));
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("AfterNoon"),
                    DropdownButton<String>(
                      value: afterNoon,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xff93cfc4),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xff93cfc4),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          afterNoon = value;
                        });
                      },
                      items: ["1", "2", "3"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value == "1"
                              ? Image.asset(
                                  "assets/images/happy.png",
                                  width: 35,
                                )
                              : value == "2"
                                  ? Image.asset(
                                      "assets/images/sad.png",
                                      width: 35,
                                    )
                                  : Image.asset(
                                      "assets/images/wizzy.png",
                                      width: 35,
                                    ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ]),
          Container(
            margin: EdgeInsets.fromLTRB(50, 5, 50, 5),
            width: MediaQuery.of(context).size.width,
            height: 2,
            child: ColoredBox(color: Color(0xff93cfc4)),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              "FOOD",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          GridView.count(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("BreakFast"),
                      DropdownButton<String>(
                        value: Breakfast,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(
                          color: Color(0xff93cfc4),
                        ),
                        underline: Container(
                          height: 2,
                          color: Color(0xff93cfc4),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            Breakfast = value;
                          });
                        },
                        items: ["1", "2", "3"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value == "1"
                                ? Image.asset(
                                    "assets/images/emptydish.jpeg",
                                    width: 35,
                                  )
                                : value == "2"
                                    ? Image.asset(
                                        "assets/images/halfdish.webp",
                                        width: 35,
                                      )
                                    : Image.asset(
                                        "assets/images/fulldish.jpg",
                                        width: 35,
                                      ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text("Lunch"),
                    DropdownButton<String>(
                      value: Lunch,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xff93cfc4),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xff93cfc4),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          Lunch = value;
                        });
                      },
                      items: ["1", "2", "3"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: value == "1"
                                ? Image.asset(
                                    "assets/images/emptydish.jpeg",
                                    width: 35,
                                  )
                                : value == "2"
                                    ? Image.asset(
                                        "assets/images/halfdish.webp",
                                        width: 35,
                                      )
                                    : Image.asset(
                                        "assets/images/fulldish.jpg",
                                        width: 35,
                                      ));
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Snack"),
                    DropdownButton<String>(
                      value: Snack,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xff93cfc4),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xff93cfc4),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          Snack = value;
                        });
                      },
                      items: ["1", "2", "3"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value == "1"
                              ? Image.asset(
                                  "assets/images/emptydish.jpeg",
                                  width: 35,
                                )
                              : value == "2"
                                  ? Image.asset(
                                      "assets/images/halfdish.webp",
                                      width: 35,
                                    )
                                  : Image.asset(
                                      "assets/images/fulldish.jpg",
                                      width: 35,
                                    ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ]),
          Container(
            margin: EdgeInsets.fromLTRB(50, 5, 50, 5),
            width: MediaQuery.of(context).size.width,
            height: 2,
            child: ColoredBox(color: Color(0xff93cfc4)),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              "Drinks",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          GridView.count(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("Water"),
                      DropdownButton<String>(
                        value: water,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(
                          color: Color(0xff93cfc4),
                        ),
                        underline: Container(
                          height: 2,
                          color: Color(0xff93cfc4),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            water = value;
                          });
                        },
                        items: ["1", "2", "3"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value == "1"
                                ? Image.asset(
                                    "assets/images/empty_water.jpeg",
                                    width: 10,
                                  )
                                : value == "2"
                                    ? Image.asset(
                                        "assets/images/halfwater.jpeg",
                                        width: 10,
                                      )
                                    : Image.asset(
                                        "assets/images/full_water.jpeg",
                                        width: 10,
                                      ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text("Milk"),
                    DropdownButton<String>(
                      value: milk,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xff93cfc4),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xff93cfc4),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          milk = value;
                        });
                      },
                      items: ["1", "2", "3"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: value == "1"
                                ? Image.asset(
                                    "assets/images/empty_water.jpeg",
                                    width: 10,
                                  )
                                : value == "2"
                                    ? Image.asset(
                                        "assets/images/halfwater.jpeg",
                                        width: 10,
                                      )
                                    : Image.asset(
                                        "assets/images/full_water.jpeg",
                                        width: 10,
                                      ));
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Juice"),
                    DropdownButton<String>(
                      value: juice,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xff93cfc4),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xff93cfc4),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          juice = value;
                        });
                      },
                      items: ["1", "2", "3"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value == "1"
                              ? Image.asset(
                                  "assets/images/empty_water.jpeg",
                                  width: 10,
                                )
                              : value == "2"
                                  ? Image.asset(
                                      "assets/images/halfwater.jpeg",
                                      width: 10,
                                    )
                                  : Image.asset(
                                      "assets/images/full_water.jpeg",
                                      width: 10,
                                    ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ]),
          Container(
            margin: EdgeInsets.fromLTRB(50, 5, 50, 5),
            width: MediaQuery.of(context).size.width,
            height: 2,
            child: ColoredBox(color: Color(0xff93cfc4)),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              "OTHERS",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: [
              Column(
                children: [
                  Text("Hygiene"),
                  Container(
                    child: TextField(
                      controller: Hygiene,
                      decoration: new InputDecoration(
                        fillColor: Color(0xFFFFFFFF),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: new BorderSide(color: Colors.teal)),
                      ),
                    ),
                    width: 50,
                    margin: EdgeInsets.all(5),
                    height: 30,
                  ),
                  Image.asset(
                    "assets/images/shield.png",
                    width: 50,
                    height: 50,
                  )
                ],
              ),
              Column(children: [
                Text("Sleep"),
                Container(
                  child: TextField(
                    controller: Sleep,
                    decoration: new InputDecoration(
                      fillColor: Color(0xFFFFFFFF),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: new BorderSide(color: Colors.teal)),
                    ),
                  ),
                  width: 50,
                  margin: EdgeInsets.all(5),
                  height: 30,
                ),
                Image.asset(
                  "assets/images/nap.png",
                  width: 50,
                  height: 50,
                )
              ]),
              Column(children: [
                Text("Temperature"),
                Container(
                  child: TextField(
                    controller: Temperature,
                    decoration: new InputDecoration(
                      fillColor: Color(0xFFFFFFFF),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: new BorderSide(color: Colors.teal)),
                    ),
                  ),
                  width: 50,
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                  height: 30,
                ),
                Image.asset(
                  "assets/images/Temperature.png",
                  width: 50,
                  height: 50,
                )
              ]),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 5, 50, 5),
            width: MediaQuery.of(context).size.width,
            height: 2,
            child: ColoredBox(color: Color(0xff93cfc4)),
          ),
          Column(children: [
            SizedBox(
              height: 5,
            ),
            Text(
              "Comment",
              style: TextStyle(
                  color: Color(0xff93cfc4),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: TextField(
                controller: Comment,
                decoration: new InputDecoration(
                  fillColor: Color(0xFFFFFFFF),
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: new BorderSide(color: Colors.teal)),
                ),
                maxLines: 5,
              ),
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 90 / 100,
            )
          ]),
          Container(
            child: ElevatedButton(
                onPressed: () async {
                  final response = await http.post(
                      Uri.parse(
                        InfixApi.SendStudentStatus + "/${widget.id}",
                      ),
                      headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': _token!,
                      },
                      body: jsonEncode({
                        "morning": "$mood",
                        "noon": "$noon",
                        "student_id": "${widget.id}",
                        "afternoon": afterNoon,
                        "Breakfast": Breakfast,
                        "Lunch": Lunch,
                        "Snack": Snack,
                        "water": water,
                        "milk": milk,
                        "juice": juice,
                        "Hygiene": Hygiene.text,
                        "Temperature": Temperature.text ?? 37.5,
                        "Sleep": Sleep.text,
                        "Comment": Comment.text ?? "Good Mood"
                      }));
                  print(response.body);
                  if (response.statusCode == 201) {
                    var jsonData = jsonDecode(response.body);
                    print(jsonData[0]);
                    Navigator.of(context).pop();
                    try {
                      // return DailyReportModel.fromJson(jsonData[0]);
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    print('Failed to load');
                  }
                },
                child: Text("Send")),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
          )
        ],
      ),
    );
  }

  Future<DailyReportModel>? dailyReport;
  late DateTime mTimeofDay;
  String? _token;
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

  Future<DailyReportModel> getDailyReport() async {
    final response = await http.get(
        Uri.parse(InfixApi.studentDailyReport + "/${widget.id}"),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      print(jsonData[0]);
      try {
        // mTimeofDay =
        //     DateTime.parse(DailyReportModel.fromJson(jsonData.last).dateOfDay!);
        mood = DailyReportModel.fromJson(jsonData.last).morning.toString();
        noon = DailyReportModel.fromJson(jsonData.last).noon.toString();

        afterNoon =
            DailyReportModel.fromJson(jsonData.last).afternoon.toString();

        Breakfast =
            DailyReportModel.fromJson(jsonData.last).breakfast.toString();

        Lunch = DailyReportModel.fromJson(jsonData.last).lunch.toString();

        Snack = DailyReportModel.fromJson(jsonData.last).snack.toString();

        water = DailyReportModel.fromJson(jsonData.last).water.toString();

        milk = DailyReportModel.fromJson(jsonData.last).milk.toString();

        juice = DailyReportModel.fromJson(jsonData.last).juice.toString();

        Hygiene.text =
            DailyReportModel.fromJson(jsonData.last).hygiene.toString();

        Temperature.text =
            DailyReportModel.fromJson(jsonData.last).temperature.toString();

        Sleep.text = DailyReportModel.fromJson(jsonData.last).sleep.toString();

        Comment.text =
            DailyReportModel.fromJson(jsonData.last).comment.toString();
        setState(() {});
        return DailyReportModel.fromJson(jsonData.last);
      } catch (e) {
        throw ('Failed to load');
        print(e);
      }
    } else {
      throw ('Failed to load');
    }
  }
}
