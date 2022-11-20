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
import 'package:infixedu/utils/model/Timeline.dart';
import 'package:infixedu/utils/widget/TimeLineView.dart';

// ignore: must_be_immutable
class TimelineScreen extends StatefulWidget {
  String id;

  TimelineScreen({this.id});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  Future<TimelineList> timelinelist;

  String _token;
  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        timelinelist = getAllTimeline(
            widget.id != null ? int.parse(widget.id) : int.parse(value));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Timeline'),
      backgroundColor: Colors.white,
      body: FutureBuilder<TimelineList>(
        future: timelinelist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.timelines.length > 0) {
              return Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data.timelines.length,
                  itemBuilder: (context, index) {
                    return TimeLineView(snapshot.data.timelines[index]);
                  },
                ),
              );
            } else {
              return Utils.noDataWidget();
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<TimelineList> getAllTimeline(dynamic id) async {
    final response = await http.get(Uri.parse(InfixApi.getStudentTimeline(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TimelineList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
