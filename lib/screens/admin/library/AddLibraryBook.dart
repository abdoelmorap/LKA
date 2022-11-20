// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/AdminBookCategory.dart';
import 'package:infixedu/utils/model/AdminBookSubject.dart';
import 'package:infixedu/utils/widget/Line.dart';

class AddAdminBook extends StatefulWidget {
  @override
  _AddAdminBookState createState() => _AddAdminBookState();
}

class _AddAdminBookState extends State<AddAdminBook> {
  String id;
  var selectedCategory;
  var selectedCategoryId;
  var selectedSubject;
  var selectedSubjectId;

  Future<AdminSubjectList> subjectList;
  Future<AdminCategoryList> categoryList;
  TextEditingController titleController = TextEditingController();
  TextEditingController bookNoController = TextEditingController();
  TextEditingController isbnNoController = TextEditingController();
  TextEditingController publisherNameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController rackNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  String _format = 'yyyy-MMMM-dd';
  DateTime date;
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _selectedaAssignDate = 'Date'.tr;

  Response response;
  Dio dio = Dio();
  String _token;

  String schoolID;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('schoolId').then((value) {
      schoolID = value;
    });

    Utils.getStringValue('id').then((value) {
      id = value;
      Utils.getStringValue('token').then((value) {
        setState(() {
          _token = value;

          subjectList = getAllSubject();
          subjectList.then((value) {
            selectedSubject = value.subjects[0].title;
            selectedSubjectId = value.subjects[0].id;
          });

          categoryList = getAllCategory();
          categoryList.then((value) {
            selectedCategory = value.categories[0].title;
            selectedCategoryId = value.categories[0].id;
          });
          //date time init
          date = DateTime.now();
          //initial date
          initDateTime =
              '${date.year}-${getAbsoluteDate(date.month)}-${getAbsoluteDate(date.day)}';
          _dateTime = DateTime.parse(initDateTime);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Add Book',
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<AdminSubjectList>(
                        future: subjectList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return getSubjectsDropdown(snapshot.data.subjects);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<AdminCategoryList>(
                        future: categoryList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return getCategoriesDropdown(
                                snapshot.data.categories);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: titleController,
                  style: Theme.of(context).textTheme.headline4,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: 'Enter title here'.tr,
                      border: InputBorder.none),
                ),
                BottomLine(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: bookNoController,
                        style: Theme.of(context).textTheme.headline4,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: 'Book number'.tr,
                            border: InputBorder.none),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: isbnNoController,
                        style: Theme.of(context).textTheme.headline4,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: 'ISBN', border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                BottomLine(),
                TextField(
                  controller: publisherNameController,
                  style: Theme.of(context).textTheme.headline4,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: 'Publisher name'.tr, border: InputBorder.none),
                ),
                BottomLine(),
                TextField(
                  controller: authorController,
                  style: Theme.of(context).textTheme.headline4,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: 'Author name'.tr, border: InputBorder.none),
                ),
                BottomLine(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: rackNoController,
                        style: Theme.of(context).textTheme.headline4,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: 'Rack number'.tr,
                            border: InputBorder.none),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        style: Theme.of(context).textTheme.headline4,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: 'Quantity'.tr, border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                BottomLine(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        controller: priceController,
                        style: Theme.of(context).textTheme.headline4,
                        decoration: InputDecoration(
                            hintText: 'Price'.tr, border: InputBorder.none),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            pickerTheme: DateTimePickerTheme(
                              confirm: Text('Done',
                                  style: TextStyle(color: Colors.red)),
                              cancel: Text('cancel',
                                  style: TextStyle(color: Colors.cyan)),
                            ),
                            minDateTime: DateTime.parse(initDateTime),
                            maxDateTime: DateTime.parse(maxDateTime),
                            initialDateTime: _dateTime,
                            dateFormat: _format,
                            locale: _locale,
                            onChange: (dateTime, List<int> index) {
                              setState(() {
                                _dateTime = dateTime;
                              });
                            },
                            onConfirm: (dateTime, List<int> index) {
                              setState(() {
                                setState(() {
                                  _dateTime = dateTime;
                                  _selectedaAssignDate =
                                      '${_dateTime.year}-${getAbsoluteDate(_dateTime.month)}-${getAbsoluteDate(_dateTime.day)}';
                                  dateController.text = _selectedaAssignDate;
                                });
                              });
                            },
                          );
                        },
                        child: Text(
                          _selectedaAssignDate,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ],
                ),
                BottomLine(),
                TextField(
                  controller: descriptionController,
                  style: Theme.of(context).textTheme.headline4,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: 'Description'.tr, border: InputBorder.none),
                ),
                BottomLine(),
                Container(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 100.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurpleAccent,
                    ),
                    onPressed: () {
                      String title = titleController.text;
                      String bookNo = bookNoController.text;
                      String isbn = isbnNoController.text;
                      String pubName = publisherNameController.text;
                      String author = authorController.text;
                      String rackNo = rackNoController.text;
                      String quantity = quantityController.text;
                      String price = priceController.text;
                      String description = descriptionController.text;

                      if (title.isNotEmpty &&
                          bookNo.isNotEmpty &&
                          isbn.isNotEmpty &&
                          id.isNotEmpty) {
                        addBookData(
                                title,
                                '$selectedCategoryId',
                                bookNo,
                                isbn,
                                pubName,
                                author,
                                '$selectedSubjectId',
                                rackNo,
                                quantity,
                                price,
                                description,
                                '$_selectedaAssignDate',
                                id)
                            .then((value) {
                          if (value) {
                            titleController.text = '';
                            bookNoController.text = '';
                            isbnNoController.text = '';
                            publisherNameController.text = '';
                            authorController.text = '';
                            rackNoController.text = '';
                            quantityController.text = '';
                            priceController.text = '';
                            descriptionController.text = '';
                          }
                        });
                      }
                    },
                    child: new Text("Save".tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSubjectsDropdown(List<AdminSubject> subjects) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: subjects.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            //_selectedClass = value;
            selectedSubject = value;
            selectedSubjectId = getCode(subjects, value);
          });
        },
        value: selectedSubject,
      ),
    );
  }

  Widget getCategoriesDropdown(List<Admincategory> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: categories.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            //_selectedClass = value;
            selectedCategory = value;
            selectedCategoryId = getCode(categories, value);
          });
        },
        value: selectedCategory,
      ),
    );
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.title == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<AdminSubjectList> getAllSubject() async {
    final response = await http.get(Uri.parse(InfixApi.subjectList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminSubjectList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AdminCategoryList> getAllCategory() async {
    final response = await http.get(Uri.parse(InfixApi.bookCategory),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminCategoryList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future<bool> addBookData(
      String title,
      String categoryId,
      String bookNo,
      String isbn,
      String publisherName,
      String authorName,
      String subjectId,
      String reckNo,
      String quantity,
      String price,
      String details,
      String date,
      String userId) async {
    FormData formData = FormData.fromMap({
      "book_title": title,
      "book_category_id": categoryId,
      "book_number": bookNo,
      "isbn_no": isbn,
      "publisher_name": publisherName,
      "author_name": authorName,
      "subject_id": subjectId,
      "rack_number": reckNo,
      "quantity": quantity,
      "book_price": price,
      "details": details,
      "post_date": date,
      "user_id": userId,
      "school_id": schoolID,
    });
    response = await dio
        .post(
      InfixApi.adminAddBook,
      data: formData,
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
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
    });
    if (response.statusCode == 200) {
      Utils.showToast('Book Added'.tr);
      return true;
    } else {
      return false;
    }
  }
}
