// 🐦 Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';

// ignore: must_be_immutable
class AddFeeType extends StatefulWidget {
  @override
  _AddFeeTypeState createState() => _AddFeeTypeState();
}

class _AddFeeTypeState extends State<AddFeeType> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descripController = TextEditingController();

  Response response;

  Dio dio = Dio();

  String _token;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Fees Type',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(hintText: 'Enter title here'.tr),
            ),
            TextField(
              controller: descripController,
              style: Theme.of(context).textTheme.headline4,
              decoration:
                  InputDecoration(hintText: 'Enter description here'.tr),
            ),
            Expanded(child: Container()),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  addFeeData(titleController.text, descripController.text)
                      .then((value) {
                    if (value) {
                      titleController.text = '';
                      descripController.text = '';
                    }
                  });
                },
                child: new Text("Save".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> addFeeData(String title, String des) async {
    response = await dio
        .get(
      InfixApi.feesDataSend(title, des),
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
      Navigator.of(context).pop();
    });
    if (response.statusCode == 200) {
      Utils.showToast('Fee Type Added'.tr);
      return true;
    } else {
      return false;
    }
  }
}
