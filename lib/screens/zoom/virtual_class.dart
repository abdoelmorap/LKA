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
import 'package:infixedu/utils/model/zoom_meeting.dart';
import 'package:infixedu/utils/widget/meeting_row.dart';

class VirtualClassScreen extends StatefulWidget {
  final uid;

  VirtualClassScreen({this.uid});

  @override
  _VirtualClassScreenState createState() => _VirtualClassScreenState();
}

class _VirtualClassScreenState extends State<VirtualClassScreen> {
  String _token;

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
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Online class',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<ZoomMeetingList>(
        future: getAllMeeting(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meetings.length < 1) {
              return Center(
                  child: Text(
                "Not available",
                style: Theme.of(context).textTheme.subtitle1,
              ));
            }
            return ListView.builder(
              itemCount: snapshot.data.meetings.length,
              itemBuilder: (context, index) {
                return ZoomMeetingRow(snapshot.data.meetings.elementAt(index));
              },
            );
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Future<ZoomMeetingList> getAllMeeting() async {
    print('URL' +
        InfixApi.getMeeting(
            uid: widget.uid, param: InfixApi.createVirtualClass));
    final response = await http.get(
        Uri.parse(InfixApi.getMeeting(
            uid: widget.uid, param: InfixApi.createVirtualClass)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData['data']['meetings']);

      return ZoomMeetingList.fromJson(jsonData['data']['meetings']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
