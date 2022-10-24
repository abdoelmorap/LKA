// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/Classes.dart';
import 'package:infixedu/utils/model/LibraryCategoryMember.dart';
import 'package:infixedu/utils/model/Section.dart';
import 'package:infixedu/utils/model/Staff.dart';
import 'package:infixedu/utils/model/Student.dart';

class AddMember extends StatefulWidget {
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final idController = TextEditingController();
  String selectedCategory;
  Future<LibraryMemberList> categoryList;
  Future classes;
  Future<SectionList> sections;
  Future<StudentList> students;
  Future<StaffList> staffs;
  dynamic selectedCategoryId;
  bool isStudentCategory = false;
  String selectedClass;
  dynamic selectedClassId;
  String selectedSection;
  dynamic selectedSectionId;
  String selectedStudent;
  dynamic selectedStudentId;
  String selectedStaff;
  dynamic selectedStaffId;
  String _id;
  String _token;
  String rule;

  bool available = true;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;

        categoryList = getAllCategory();

        categoryList.then((value) {
          setState(() {
            selectedCategory = value.members[0].name;
            selectedCategoryId = value.members[0].id;
            staffs = getAllStaff(selectedCategoryId);
            staffs.then((staffVal) {
              setState(() {
                selectedStaff = staffVal.staffs[0].name;
                selectedStaffId = staffVal.staffs[0].userId;
              });
            });
          });
        });
        Utils.getStringValue('id').then((value) {
          setState(() {
            _id = value;
            Utils.getStringValue('rule').then((ruleValue) {
              setState(() {
                rule = ruleValue;
                classes = getAllClass(int.parse(_id));
                classes.then((value) {
                  selectedClass = value.classes[0].name;
                  selectedClassId = value.classes[0].id;
                  sections = getAllSection(int.parse(_id), selectedClassId);
                  sections.then((sectionValue) {
                    selectedSection = sectionValue.sections[0].name;
                    selectedSectionId = sectionValue.sections[0].id;
                    students = getAllStudent();
                    students.then((value) {
                      selectedStudent = value.students[0].name;
                      selectedStudentId = value.students[0].uid;
                    });
                  });
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
        title: 'Add Member',
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: idController,
                style: Theme.of(context).textTheme.headline4,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Enter ID Here'.tr,
                  border: InputBorder.none,
                ),
              ),
            ),
            FutureBuilder<LibraryMemberList>(
              future: categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return getCategoryDropdown(snapshot.data.members);
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder(
              future: classes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return isStudentCategory
                      ? getClassDropdown(snapshot.data.classes)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<SectionList>(
              future: sections,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return isStudentCategory
                      ? getSectionDropdown(snapshot.data.sections)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<StaffList>(
              future: staffs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return !isStudentCategory
                      ? getStaffDropDown(snapshot.data.staffs)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<StudentList>(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return isStudentCategory
                      ? getStudentDropdown(snapshot.data.students)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0, top: 100.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  if (selectedCategoryId == 2) {
                    if (idController.text.isNotEmpty) {
                      addMemberData(
                              '$selectedCategoryId',
                              idController.text,
                              '$selectedClassId',
                              '$selectedSectionId',
                              '$selectedStudentId',
                              '0',
                              _id)
                          .then((val) {
                        if (val) {
                          idController.text = '';
                        }
                      });
                    } else {
                      Utils.showToast('Enter unique id'.tr);
                    }
                  } else {
                    if (idController.text.isNotEmpty) {
                      addMemberData(
                              '$selectedCategoryId',
                              idController.text,
                              '$selectedClassId',
                              '$selectedSectionId',
                              '0',
                              '$selectedStaffId',
                              _id)
                          .then((val) {
                        if (val) {
                          idController.text = '';
                        }
                      });
                    } else {
                      Utils.showToast('Enter unique id'.tr);
                    }
                  }
                },
                child: new Text("Save".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryDropdown(List<LibraryMember> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: categories.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
            selectedCategoryId = getCode(categories, value);
            switch (selectedCategoryId) {
              case 2:
                setState(() {
                  isStudentCategory = true;
                });
                break;
              default:
                setState(() {
                  isStudentCategory = false;
                  staffs = getAllStaff(selectedCategoryId);
                  staffs.then((staffVal) {
                    setState(() {
                      if (staffVal.staffs.length == 0) {
                        Utils.showToast('No staffs found'.tr);
                      }
                      selectedStaff = staffVal.staffs[0].name;
                      selectedStaffId = staffVal.staffs[0].userId;
                    });
                  });
                });
                break;
            }
          });
        },
        value: selectedCategory,
      ),
    );
  }

  Widget getClassDropdown(List classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedClass = value;
            selectedClassId = getCode(classes, value);
            students = getAllStudent();
            students.then((value) {
              if (value.students.length == 0) {
                Utils.showToast('No student found'.tr);
              }
              selectedStudent = value.students[0].name;
              selectedStudentId = value.students[0].uid;
            });
          });
        },
        value: selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sections) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sections.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedSection = value;
            selectedSectionId = getCode(sections, value);
            students = getAllStudent();
            students = getAllStudent();
            students.then((value) {
              if (value.students.length == 0) {
                Utils.showToast('No student found'.tr);
              }
              selectedStudent = value.students[0].name;
              selectedStudentId = value.students[0].uid;
            });
          });
        },
        value: selectedSection,
      ),
    );
  }

  Widget getStaffDropDown(List<Staff> staff) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: staff.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedStaff = value;
            selectedStaffId = getCode2(staff, value);
            // staffs = getAllStaff(selectedStaffId);
            //
            // staffs = getAllStaff(selectedCategoryId);
            // staffs.then((staffVal) {
            //   if (staffVal.staffs.length == 0) {
            //     Utils.showToast('No staff found');
            //   }
            //   selectedStaff = value;
            //   selectedStaffId = getCode(staff, value);
            //   print('Staff Name: $selectedStaff Staff ID: $selectedStaffId');
            // });
          });
        },
        value: selectedStaff,
      ),
    );
  }

  Widget getStudentDropdown(List<Student> student) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: student.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedStudent = value;
            selectedStudentId = getCode(student, value);
            students = getAllStudent();
          });
        },
        value: selectedStudent,
      ),
    );
  }

  Future<LibraryMemberList> getAllCategory() async {
    final response = await http.get(
        Uri.parse(InfixApi.getLibraryMemberCategory),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LibraryMemberList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
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

  int getCode2<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.studentId;
        break;
      }
    }
    return code;
  }

  Future<SectionList> getAllSection(dynamic id, dynamic classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(
          id,
          classId,
        )),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future getAllClass(dynamic id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getClassById(
          id,
        )),
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

  Future<StudentList> getAllStudent() async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentByClassAndSection(
          selectedClassId,
          selectedSectionId,
        )),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<StaffList> getAllStaff(dynamic staffId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getAllStaff(
          staffId,
        )),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<bool> addMemberData(
      String categoryId,
      String uID,
      String classId,
      String sectionId,
      String studentId,
      String stuffId,
      String createdBy) async {
    Response response;
    Dio dio = Dio();
    response = await dio
        .post(
      InfixApi.addLibraryMember(
        categoryId,
        uID,
        classId,
        sectionId,
        studentId,
        stuffId,
        createdBy,
      ),
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showToast(errorMessage);
    });
    if (response.statusCode == 200) {
      Utils.showToast('Member Added'.tr);
      return true;
    } else {
      return false;
    }
  }
}
