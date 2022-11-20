// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/StudentHomework.dart';

class UploadHomework extends StatefulWidget {
  final Homework homework;
  final String userID;

  UploadHomework({this.homework, this.userID});

  @override
  _UploadHomeworkState createState() => _UploadHomeworkState();
}

class _UploadHomeworkState extends State<UploadHomework> {
  // File _file;

  List<File> files;
  List<String> fileNames = [];
  String _token;
  bool isResponse = false;

  // double progress = 0.0;

  Future pickDocument(context) async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    print(result);
    if (result != null) {
      setState(() {
        files = result.paths.map((path) => File(path)).toList();
        files.forEach((element) {
          fileNames.add(element.path.toString().split('/').last);
        });
      });
    } else {
      Utils.showToast('Cancelled picking docuement');
    }
  }

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Material(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          pickDocument(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: files == null
                                        ? Text(
                                            'Select Homework file',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .copyWith(),
                                            maxLines: 2,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                                files.length,
                                                (index) => Text(
                                                      '$index - ${fileNames[index]}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(),
                                                    )),
                                          ),
                                  ),
                                ),
                                Text(
                                  'Browse',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (files != null) {
                            setState(() {
                              isResponse = true;
                            });
                            List<MultipartFile> multipart = [];

                            for (int i = 0; i < files.length; i++) {
                              multipart.add(await MultipartFile.fromFile(
                                  files[i].path,
                                  filename: files[i].path));
                            }
                            FormData formData = FormData.fromMap({
                              "user_id": widget.userID,
                              "homework_id": widget.homework.id,
                              'files[]': multipart,
                            });

                            Response response;
                            var dio = Dio();

                            response = await dio.post(
                              InfixApi.studentUploadHomework,
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
                                  print((received / total * 100)
                                          .toStringAsFixed(0) +
                                      '%');
                                }
                              },
                            ).catchError((e) {
                              final errorMessage =
                                  DioExceptions.fromDioError(e).toString();
                              Utils.showToast(errorMessage);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });

                            if (response.statusCode == 200) {
                              setState(() {
                                isResponse = false;
                              });
                              var data = json.decode(response.toString());
                              if (data['success'] == true) {
                                Utils.showToast('Homework Upload successfully');
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                Utils.showToast('Some error occurred');
                              }
                            } else {
                              setState(() {
                                isResponse = true;
                              });
                            }
                          } else {
                            Utils.showToast(
                                'Please select homework file before submit');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(145),
                          height: ScreenUtil().setHeight(40),
                          decoration: Utils.gradientBtnDecoration,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.cloud_upload),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Submit",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isResponse == true
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
