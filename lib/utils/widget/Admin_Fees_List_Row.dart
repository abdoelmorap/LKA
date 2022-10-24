// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/AdminFees.dart';
import 'Line.dart';

// ignore: must_be_immutable
class AdminFeesListRow extends StatefulWidget {
  AdminFees adminFees;

  AdminFeesListRow(this.adminFees);

  @override
  _AdminFeesListRowState createState() => _AdminFeesListRowState();
}

class _AdminFeesListRowState extends State<AdminFeesListRow> {
  GlobalKey _scaffold = GlobalKey();
  Response response;
  Dio dio = Dio();
  String _token;

  TextEditingController titleController, descripController;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            widget.adminFees.name ?? 'NA',
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            widget.adminFees.description ?? 'NA',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: InkWell(
            child: Text(
              'Update',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(decoration: TextDecoration.underline),
            ),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ),
        BottomLine(),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    titleController = TextEditingController();
    descripController = TextEditingController();
    titleController.text = widget.adminFees.name;
    descripController.text = widget.adminFees.description;

    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 20.0, right: 10.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: titleController,
                              style: Theme.of(context).textTheme.headline4,
                              decoration:
                                  InputDecoration(hintText: 'Enter title here'),
                            ),
                            TextField(
                              controller: descripController,
                              style: Theme.of(context).textTheme.headline4,
                              decoration: InputDecoration(
                                  hintText: 'Enter discription here'),
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
                                  updateFeeData(
                                          titleController.text,
                                          descripController.text,
                                          widget.adminFees.id,
                                          context)
                                      .then((value) {
                                    if (value) {
                                      setState(() {
                                        widget.adminFees.name =
                                            titleController.text;
                                        widget.adminFees.description =
                                            descripController.text;
                                      });
                                    }
                                  });
                                },
                                child: new Text("Save"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            },
                            child: Icon(Icons.close,color: Colors.black,)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> updateFeeData(
      String title, String des, dynamic id, BuildContext context) async {
    response = await dio
        .get(
      InfixApi.feesDataUpdate(title, des, id),
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
      Utils.showToast(errorMessage);
      Navigator.of(context).pop();
    });
    if (response.statusCode == 200) {
      Utils.showToast('Updated successfully');
      Navigator.of(context).pop();
      return true;
    } else {
      return false;
    }
  }
}
