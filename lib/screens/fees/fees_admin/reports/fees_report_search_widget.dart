import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Classes.dart';
import 'package:infixedu/utils/model/Section.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FeesReportSearchWidget extends StatefulWidget {
  final Function(String, int, int) onTap;
  FeesReportSearchWidget({this.onTap});
  @override
  _FeesReportSearchWidgetState createState() => _FeesReportSearchWidgetState();
}

class _FeesReportSearchWidgetState extends State<FeesReportSearchWidget> {
  final TextEditingController datePickerController = TextEditingController();

  String _token;
  String rule;
  String _id;
  Future classes;
  Future<SectionList> sections;

  dynamic classId;
  dynamic sectionId;
  String _selectedClass;
  String _selectedSection;

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

  Future<SectionList> getAllSection(dynamic id, dynamic classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));

    print(InfixApi.getSectionById(id, classId));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    Utils.getStringValue('token').then((value) async {
      setState(() {
        _token = value;
        Utils.getStringValue('id').then((idValue) {
          _id = idValue;
          Utils.getStringValue('rule').then((ruleValue) {
            rule = ruleValue;
            classes = getAllClass(int.parse(_id));
            classes.then((value) {
              _selectedClass = value.classes[0].name;
              classId = value.classes[0].id;
              sections = getAllSection(int.parse(_id), classId);
              sections.then((sectionValue) {
                _selectedSection = sectionValue.sections[0].name;
                sectionId = sectionValue.sections[0].id;
              });
            });
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: classes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final initialDate = DateTime.now();
                      final DateTimeRange picked = await showDateRangePicker(
                        context: context,
                        helpText: 'Select start and End Date',
                        fieldStartHintText: 'Start Date',
                        fieldEndHintText: 'End Date',
                        currentDate: initialDate,
                        firstDate: DateTime(
                            1900, initialDate.month + 1, initialDate.day),
                        lastDate: DateTime(
                            2100, initialDate.month + 1, initialDate.day),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: Colors.deepPurple,
                              appBarTheme: AppBarTheme(
                                color: Colors.deepPurple,
                              ),
                            ),
                            child: child,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() {
                          datePickerController.text =
                              "${DateFormat('MM/dd/yyyy').format(picked.start)} - ${DateFormat('MM/dd/yyyy').format(picked.end)}";
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: datePickerController,
                        enabled: false,
                        style: Theme.of(context).textTheme.headline4,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Select Date",
                          hintStyle: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  getClassDropdown(snapshot.data.classes),
                  SizedBox(
                    height: 10,
                  ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50.0,
                        decoration: Utils.gradientBtnDecoration,
                        child: Text(
                          "Search".tr,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      onTap: () {
                        widget.onTap(
                            datePickerController.text, classId, sectionId);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }),
    );
  }

  Widget getClassDropdown(List classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        isDense: false,
        items: classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15),
        onChanged: (value) {
          setState(() {
            _selectedClass = value;
            classId = getCode(classes, value);

            sections = getAllSection(int.parse(_id), classId);
            sections.then((sectionValue) {
              _selectedSection = sectionValue.sections[0].name;
              sectionId = sectionValue.sections[0].id;
            });

            debugPrint('User select class $classId');
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15),
        onChanged: (value) {
          setState(() {
            _selectedSection = value;

            sectionId = getCode(sectionlist, value);

            sections = getAllSection(int.parse(_id), classId);

            debugPrint('User select section $sectionId');
          });
        },
        value: _selectedSection,
      ),
    );
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
}
