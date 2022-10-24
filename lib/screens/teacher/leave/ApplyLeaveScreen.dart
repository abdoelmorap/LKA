// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/LeaveType.dart';
import 'package:infixedu/utils/permission_check.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'LeaveListScreen.dart';

class ApplyLeaveScreen extends StatefulWidget {
  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String _id;
  String applyDate;
  String fromDate;
  String toDate;
  String leaveType;
  dynamic leaveId;
  TextEditingController reasonController = TextEditingController();
  DateTime date;
  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  File _file;
  bool isResponse = false;
  Response response;
  Dio dio = new Dio();
  Future<LeaveList> leaves;
  String _token;
  bool leaveAvailable = true;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          _id = value;
          date = DateTime.now();
          initDateTime =
              '${date.year}-${getAbsoluteDate(date.month)}-${getAbsoluteDate(date.day)}';
          _dateTime = DateTime.parse(initDateTime);
          leaves = getAllLeaveType(_id);
          leaves.then((value) {
            setState(() {
              if (value.types.length != 0) {
                leaveAvailable = true;
                leaveId = value.types[0].id;
                leaveType = value.types[0].type;
              } else {
                leaveAvailable = false;
              }
            });
          });
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PermissionCheck().checkPermissions(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Apply Leave',
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: getContent(context),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          leaveAvailable
              ? GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: Utils.gradientBtnDecoration,
                      child: Text(
                        "Save".tr,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                  ),
                  onTap: () {
                    String reason = reasonController.text;

                    if (reason.isNotEmpty && _file.path.isNotEmpty) {
                      setState(() {
                        isResponse = true;
                      });
                      uploadLeave();
                      // addLeaveData();
                    } else {
                      Utils.showToast('Check all the field'.tr);
                    }
                  },
                )
              : Container(
                  child: Text(
                    "No Leave type Available. Please check back later".tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
          isResponse == true
              ? LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                )
              : Text(''),
        ],
      ),
    );
  }

  Widget getContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<LeaveList>(
            future: leaves,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    getLeaveTypeDropdown(snapshot.data.types),
                    SizedBox(
                      height: 20,
                    ),
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
                          minDateTime: DateTime.parse(initDateTime),
                          maxDateTime: DateTime.parse(maxDateTime),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (dateTime, List<int> index) {
                            setState(() {
                              _dateTime = dateTime;
                            });
                          },
                          onConfirm: (dateTime, List<int> index) {
                            setState(() {
                              setState(() {
                                _dateTime = dateTime;
                                print(
                                    '${_dateTime.year}-0${_dateTime.month}-${_dateTime.day}');
                                applyDate =
                                    '${_dateTime.year}-${getAbsoluteDate(_dateTime.month)}-${getAbsoluteDate(_dateTime.day)}';
                              });
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
                                  applyDate == null
                                      ? 'Apply Date'.tr
                                      : applyDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(12.0)),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black12,
                              size: ScreenUtil().setSp(16.0),
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
                    SizedBox(
                      height: 5,
                    ),
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
                          minDateTime: DateTime.parse(initDateTime),
                          maxDateTime: DateTime.parse(maxDateTime),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (dateTime, List<int> index) {
                            setState(() {
                              _dateTime = dateTime;
                            });
                          },
                          onConfirm: (dateTime, List<int> index) {
                            setState(() {
                              setState(() {
                                _dateTime = dateTime;
                                print(
                                    '${_dateTime.year}-0${_dateTime.month}-${_dateTime.day}');
                                fromDate =
                                    '${_dateTime.year}-${getAbsoluteDate(_dateTime.month)}-${getAbsoluteDate(_dateTime.day)}';
                              });
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
                                  fromDate == null ? 'From Date'.tr : fromDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(12.0)),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black12,
                              size: ScreenUtil().setSp(16.0),
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
                    SizedBox(
                      height: 5,
                    ),
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
                          minDateTime: DateTime.parse(initDateTime),
                          maxDateTime: DateTime.parse(maxDateTime),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (dateTime, List<int> index) {
                            setState(() {
                              _dateTime = dateTime;
                            });
                          },
                          onConfirm: (dateTime, List<int> index) {
                            setState(() {
                              setState(() {
                                _dateTime = dateTime;
                                toDate =
                                    '${_dateTime.year}-${getAbsoluteDate(_dateTime.month)}-${getAbsoluteDate(_dateTime.day)}';
                              });
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
                                  toDate == null ? 'To Date'.tr : toDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(12.0)),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black12,
                              size: ScreenUtil().setSp(16.0),
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
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        pickDocument();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  _file == null
                                      ? 'Select file'.tr
                                      : _file.path.split('/').last,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(12.0)),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Text('Browse'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                        decoration: TextDecoration.underline)),
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.headline4,
                        controller: reasonController,
                        decoration: InputDecoration(
                            hintText: "Reason".tr,
                            labelText: "Reason".tr,
                            labelStyle: Theme.of(context).textTheme.headline4,
                            errorStyle: TextStyle(
                                color: Colors.pinkAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
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
      ],
    );
  }

  Widget getLeaveTypeDropdown(List<LeaveType> leaves) {
    return leaveAvailable
        ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: DropdownButton(
              elevation: 0,
              isExpanded: true,
              items: leaves.map((item) {
                return DropdownMenuItem<String>(
                  value: item.type,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                    child: Text(
                      item.type,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                );
              }).toList(),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontSize: 15.0),
              onChanged: (value) {
                setState(() {
                  leaveType = value;
                  leaveId = getLeaveId(leaves, value);
                });
              },
              value: leaveType,
            ),
          )
        : Container();
  }

  int getLeaveId<T>(T t, String type) {
    int code;
    for (var s in t) {
      if (s.type == type) {
        code = s.id;
      }
    }
    return code;
  }

  Future<LeaveList> getAllLeaveType(id) async {
    final response = await http.get(Uri.parse(InfixApi.userLeaveType(_id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  void sentNotificationTo() async {
    final response = await http.get(Uri.parse(InfixApi.sentNotificationForAll(
        1, 'Leave', 'New leave request has come')));
    if (response.statusCode == 200) {}
  }

  void uploadLeave() async {
    FormData formData = FormData.fromMap({
      "apply_date": '$applyDate',
      "leave_type": '$leaveId',
      "leave_from": '$fromDate',
      "leave_to": toDate,
      "login_id": _id,
      "reason": reasonController.text,
      "attach_file": await MultipartFile.fromFile(_file.path),
    });
    response = await dio.post(
      InfixApi.userApplyLeaveStore,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          // progress = (received / total * 100).toDouble();
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
      Utils.showToast(errorMessage);
    });

    print(response.data.toString());
    if (response.statusCode == 200) {
      Utils.showToast('Leave applied. Please wait for approval'.tr);
      sentNotificationTo();
      Navigator.pop(context);
    } else {
      Utils.showToast(response.statusCode.toString());
    }
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future pickDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select File",
      allowCompression: true,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) {},
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path);
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  void addLeaveData() async {
    response = await dio.get(InfixApi.sendLeaveData('$applyDate', '$leaveId',
        '$fromDate', '$toDate', _id, reasonController.text, _file.path));
    if (response.statusCode == 200) {
      Utils.showToast('Leave sent successful'.tr);
      sentNotificationTo();
      Navigator.pop(context);
      Navigator.push(context, ScaleRoute(page: LeaveListScreen()));
    } else {}
  }
}
