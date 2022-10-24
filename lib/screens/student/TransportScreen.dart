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
import 'package:infixedu/utils/model/Transport.dart';
import 'package:infixedu/utils/widget/TransportRow.dart';

class TransportScreen extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<TransportScreen> {
  Future<TransportList> transports;

  String _token;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
    })
      ..then((value) {
        transports = getAllTransport();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(title: 'Transport'),
        backgroundColor: Colors.white,
        body: FutureBuilder<TransportList>(
          future: transports,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.transports.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.transports.length,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) {
                    return TransportRow(snapshot.data.transports[index]);
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
        ));
  }

  Future<TransportList> getAllTransport() async {
    final response = await http.get(Uri.parse(InfixApi.studentTransportList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return TransportList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
