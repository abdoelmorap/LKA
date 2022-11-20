import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeesGroup.dart';
import 'package:http/http.dart' as http;

class FeesGroupScreen extends StatefulWidget {
  @override
  _FeesGroupScreenState createState() => _FeesGroupScreenState();
}

class _FeesGroupScreenState extends State<FeesGroupScreen> {
  Future<FeeGroupList> fees;

  String _token;

  TextEditingController titleController, descripController;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        fees = getFeesGroups();
      });
    });
  }

  Future<FeeGroupList> getFeesGroups() async {
    final response = await http.get(Uri.parse(InfixApi.adminFeeList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeeGroupList.fromJson(jsonData['feesGroups']);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fees Group',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<FeeGroupList>(
        future: fees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.feeGroups.length,
                itemBuilder: (context, index) {
                  FeeGroup feeGroup = snapshot.data.feeGroups[index];

                  return ListTile(
                    title: Text(
                      feeGroup.name ?? 'NA',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      "${feeGroup.description ?? 'NA'}",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showUpdateDialog(feeGroup);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            final response = await http.post(
                              Uri.parse(InfixApi.adminFeesGroupDelete),
                              headers: Utils.setHeader(_token),
                              body: jsonEncode({
                                'id': feeGroup.id,
                              }),
                            );
                            if (response.statusCode == 200) {
                              setState(() {
                                fees = getFeesGroups();
                              });
                              Utils.showToast('Deleted successfully');
                              return true;
                            } else {
                              return false;
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog();
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.deepPurpleAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddDialog() {
    titleController = TextEditingController();
    descripController = TextEditingController();

    Get.dialog(
      Scaffold(
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
                              onPressed: () async {
                                final response = await http.post(
                                  Uri.parse(InfixApi.adminFeesGroupStore),
                                  headers: Utils.setHeader(_token),
                                  body: jsonEncode({
                                    'name': titleController.text,
                                    'description': descripController.text,
                                  }),
                                );
                                if (response.statusCode == 200) {
                                  Utils.showToast('Added successfully');

                                  setState(() {
                                    fees = getFeesGroups();
                                  });
                                  Get.back();
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                              child: new Text("Add".tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showUpdateDialog(FeeGroup feeGroup) {
    titleController = TextEditingController();
    descripController = TextEditingController();
    titleController.text = feeGroup.name;
    descripController.text = feeGroup.description;

    Get.dialog(
      Scaffold(
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
                              onPressed: () async {
                                final response = await http.post(
                                  Uri.parse(InfixApi.adminFeesGroupUpdate),
                                  headers: Utils.setHeader(_token),
                                  body: jsonEncode({
                                    'name': titleController.text,
                                    'description': descripController.text,
                                    'id': feeGroup.id
                                  }),
                                );
                                if (response.statusCode == 200) {
                                  Utils.showToast('Updated successfully');

                                  setState(() {
                                    fees = getFeesGroups();
                                  });
                                  Get.back();
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                              child: new Text("Update".tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
