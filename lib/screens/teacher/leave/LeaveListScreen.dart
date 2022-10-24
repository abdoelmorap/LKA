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
import 'package:infixedu/utils/model/Leave.dart';
import 'package:infixedu/utils/widget/Leave_row.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  Future<LeaveList> leaves;
  String _token;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          leaves = fetchLeave(int.parse(value));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Leave List'),
      backgroundColor: Colors.white,
      body: FutureBuilder<LeaveList>(
        future: leaves,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot != null) {
            return ListView.builder(
              itemCount: snapshot.data.leaves.length,
              itemBuilder: (context, index) {
                return LeaveRow(snapshot.data.leaves[index]);
              },
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<LeaveList> fetchLeave(int id) async {
    print(InfixApi.getLeaveList(id));
    final response = await http.get(Uri.parse(InfixApi.getLeaveList(id)),headers: Utils.setHeader(_token.toString()));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return LeaveList.fromJson(jsonData['data']['leave_list']);
    } else {
      throw Exception('failed to load');
    }
  }
}
