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
import 'package:infixedu/utils/model/Notice.dart';
import 'package:infixedu/utils/widget/NoticeRow.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  Future<NoticeList> notices;

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
        notices = getNotices(int.parse(value));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Notice'),
      backgroundColor: Colors.white,
      body: FutureBuilder<NoticeList>(
        future: notices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.notices.length > 0) {
              return ListView.separated(
                itemCount: snapshot.data.notices.length,
                itemBuilder: (context, index) {
                  return NoticRowLayout(snapshot.data.notices[index]);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Divider(
                      color: Colors.deepPurple,
                      thickness: 0.5,
                    ),
                  );
                },
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

  Future<NoticeList> getNotices(dynamic id) async {
    final response = await http.get(Uri.parse(InfixApi.getNoticeUrl(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return NoticeList.fromJson(jsonData['data']['allNotices']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
