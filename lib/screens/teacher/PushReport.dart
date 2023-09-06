import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
  String? mood = "0";
  String? noon = "0";

  String? afterNoon = "0";

  String? Breakfast = "0";

  String? Lunch = "0";

  String? Snack = "0";

  String? water = "0";

  String? milk = "0";

  String? juice = "0";

  TextEditingController Hygiene = TextEditingController();
  TextEditingController breakDetails = TextEditingController();
  TextEditingController lunchDetails = TextEditingController();
  TextEditingController SnaksDetails = TextEditingController();

  TextEditingController Activities = TextEditingController();
  TextEditingController Toilet1 = TextEditingController();
  TextEditingController Toilet2 = TextEditingController();

  TextEditingController Temperature = TextEditingController();

  TextEditingController Sleep = TextEditingController();

  TextEditingController Comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,

        appBar: CustomAppBarWidget(
          title: "Send Student Report",
        ),
        body:
        SingleChildScrollView(
          reverse: false,
          child: Column(
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
                  "Mood".tr,
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
                          Text("Morning".tr),
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
                            items: ["0", "1", "2", "3"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: value == "0"
                                    ? Image.asset(
                                        "assets/images/na.png",
                                        width: 35,
                                      )
                                    : value == "1"
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
                        Text("Noon".tr),
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
                          items: ["0", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: value == "0"
                                    ? Image.asset(
                                        "assets/images/na.png",
                                        width: 35,
                                      )
                                    : value == "1"
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
                        Text("AfterNoon".tr),
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
                          items: ["0", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: value == "0"
                                  ? Image.asset(
                                      "assets/images/na.png",
                                      width: 35,
                                    )
                                  : value == "1"
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
              ),  SizedBox(
                height: 20,
              ),
              Align(
                child: Text(
                  "FOOD".tr,
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

                    Container(
                      child: Row(children: [
                        SizedBox(width: 15,),
                        Column(
                          children: [
                            Text("BreakFast".tr),
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
                              items: ["0", "1", "2", "3"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: value == "0"
                                      ? Image.asset(
                                    "assets/images/na.png",
                                    width: 35,
                                  )
                                      : value == "1"
                                      ? Image.asset(
                                    "assets/images/plate.png",
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
                        ),     Container(
                          child: TextField(
                            controller: breakDetails,
                            decoration: new InputDecoration(
                              fillColor: Color(0xFFFFFFFF),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: new BorderSide(color: Colors.teal)),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width*60/100
                          ,margin: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          height: 40,
                        ),
                      ],)
                    ),
          Row(children: [
            SizedBox(width: 15,), Column(
                      children: [
                        Text("Lunch".tr),
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
                          items: ["0", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: value == "0"
                                    ? Image.asset(
                                        "assets/images/na.png",
                                        width: 35,
                                      )
                                    : value == "1"
                                        ? Image.asset(
                                            "assets/images/plate.png",
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
                    ),   Container(
              child: TextField(
                maxLines: 1,
                controller: lunchDetails,
                decoration: new InputDecoration(
                  fillColor: Color(0xFFFFFFFF),
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: new BorderSide(color: Colors.teal)),
                ),
              ),
              width: MediaQuery.of(context).size.width*60/100
              ,margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              height: 40,
            ),
          ],),

          Row(children: [
            SizedBox(width: 15,), Column(
          children: [
                        Text("Snack".tr),
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
                          items: ["0", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: value == "0"
                                  ? Image.asset(
                                      "assets/images/na.png",
                                      width: 35,
                                    )
                                  : value == "1"
                                      ? Image.asset(
                                          "assets/images/plate.png",
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

                  ]), Container(
            child: TextField(
              maxLines: 1,
              controller: SnaksDetails,
              decoration: new InputDecoration(
                fillColor: Color(0xFFFFFFFF),
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
            ),
            width: MediaQuery.of(context).size.width*60/100
            ,margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            height: 40,
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
                  "Drink".tr,
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
                          Text("Water".tr),
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
                            items: ["0", "1", "2", "3"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: value == "1"
                                    ? Image.asset(
                                        "assets/images/empty_water.jpeg",
                                        width: 10,
                                      )
                                    : value == "0"
                                        ? Image.asset(
                                            "assets/images/na.png",
                                            width: 35,
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
                        Text("Milk".tr),
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
                          items: ["0", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: value == "0"
                                    ? Image.asset(
                                        "assets/images/na.png",
                                        width: 35,
                                      )
                                    : value == "1"
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
                        Text("Juice".tr),
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
                          items: ["0", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: value == "0"
                                  ? Image.asset(
                                      "assets/images/na.png",
                                      width: 35,
                                    )
                                  : value == "1"
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
                  "OTHERS".tr,
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
                children: [  Column(
                  children: [
                    Text("Hands".tr),
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
                      width: 65,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: 35,
                    ),
                    Image.asset(
                      "assets/images/shield.png",
                      width: 50,
                      height: 50,
                    )
                  ],
                ),  Column(
                  children: [
                    Text("Toilet1".tr),
                    Container(
                      child: TextField(
                        controller: Toilet1,
                        decoration: new InputDecoration(
                          fillColor: Color(0xFFFFFFFF),
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: new BorderSide(color: Colors.teal)),
                        ),
                      ),
                      width: 65,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: 35,
                    ),
                    Image.asset(
                      "assets/images/toolet1.png",
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
                  Column(
                    children: [
                      Text("Toilet2".tr),
                      Container(
                        child: TextField(
                          controller: Toilet2,
                          decoration: new InputDecoration(
                            fillColor: Color(0xFFFFFFFF),
                            border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: new BorderSide(color: Colors.teal)),
                          ),
                        ),
                        width: 65,
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        height: 35,
                      ),
                      Image.asset(
                        "assets/images/toolet2.jpg",
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                  Column(children: [
                    Text("Sleep".tr),
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
                      width: 65,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: 35,
                    ),
                    Image.asset(
                      "assets/images/nap.png",
                      width: 50,
                      height: 50,
                    )
                  ]),
                  Column(children: [
                    Text("Temperature".tr),
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
                      width: 65,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: 35,
                    ),
                    Image.asset(
                      "assets/images/Temperature.png",
                      width: 50,
                      height: 50,
                    ),
                  ]),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50, 5, 50, 5),
                width: MediaQuery.of(context).size.width,
                height: 2,
                child: ColoredBox(color: Color(0xff93cfc4)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Comment".tr,
                style: TextStyle(
                    color: Color(0xff93cfc4),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: TextFormField(
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
              ),   SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50, 5, 50, 5),
                width: MediaQuery.of(context).size.width,
                height: 2,
                child: ColoredBox(color: Color(0xff93cfc4)),
              ),
              Text(
                "Activities".tr,
                style: TextStyle(
                    color: Color(0xff93cfc4),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: TextFormField(
                  controller: Activities,
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
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () async {
                      if (Hygiene.text.isEmpty || Hygiene.text == null) {
                        Fluttertoast.showToast(
                            msg: "HygieneFieldIsEmpty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return null;
                      }
                      if (Temperature.text.isEmpty || Hygiene.text == null) {
                        Fluttertoast.showToast(
                            msg: "TemperatureFieldIsEmpty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return null;
                      }
                      if (Sleep.text.isEmpty || Hygiene.text == null) {
                        Fluttertoast.showToast(
                            msg: "SleepFieldIsEmpty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return null;
                      }
                      if (Comment.text.isEmpty || Hygiene.text == null) {
                        Fluttertoast.showToast(
                            msg: "CommentFieldIsEmpty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return null;
                      }
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
                            "Activity": Activities.text,
                            "breakfast_details": breakDetails.text,
                            "launch_details": lunchDetails.text,
                            "snaks_details": SnaksDetails.text,
                            "ToiletNo1": Toilet1.text,
                            "ToiletNo2": Toilet2.text,

                            "Temperature": Temperature.text ?? 37.5,
                            "Sleep": Sleep.text,
                            "Comment": Comment.text ?? "Good Mood"
                          }));
                      print(response.body);
                      if (response.statusCode == 201) {
                        var jsonData = jsonDecode(response.body);
                        print(jsonData[0]);
                        try {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  content: Text("Report Sent Successfully"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();

                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Okay"))
                                  ],
                                );
                              });
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
              ),
          SizedBox(height: 400,)  ],
          ),

        ));
  }

  Future<DailyReportModel>? dailyReport;
  DateTime? mTimeofDay;
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
