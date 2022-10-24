// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Child.dart';
import 'package:infixedu/utils/widget/ChildRow.dart';

class ChildListScreen extends StatefulWidget {
  @override
  _ChildListScreenState createState() => _ChildListScreenState();
}

class _ChildListScreenState extends State<ChildListScreen> {
  Future<ChildList> childs;
  String _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        Utils.getStringValue('id').then((value) {
          setState(() {
            childs = getAllStudent(value);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Child List',
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<ChildList>(
        future: childs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.students.length,
              itemBuilder: (context, index) {
                return ChildRow(snapshot.data.students[index], _token);
              },
            );
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Future<ChildList> getAllStudent(String id) async {
    final response = await http.get(Uri.parse(InfixApi.getParentChildList(id)),
        headers: Utils.setHeader(_token.toString()));
    print(id);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return ChildList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
