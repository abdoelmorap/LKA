// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/ScheduleList.dart';
import 'package:infixedu/utils/widget/ShimmerListWidget.dart';
import '../Utils.dart';
import 'RoutineRowWidget.dart';

// ignore: must_be_immutable
class RoutineRow extends StatefulWidget {

  String title;
  dynamic classCode;
  dynamic sectionCode;
  String id;


  RoutineRow({this.title, this.classCode, this.sectionCode,this.id});

  @override
  _ClassRoutineState createState() => _ClassRoutineState(title,classCode,sectionCode);
}

class _ClassRoutineState extends State<RoutineRow> {

  String title;
  dynamic classCode;
  dynamic sectionCode;
  Future<ScheduleList> routine;
  String _token;


  _ClassRoutineState(this.title, this.classCode, this.sectionCode);

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
        if(classCode == null && sectionCode == null){
          routine = fetchRoutine(int.parse(widget.id!= null ? widget.id : value), title);
        }else{
          routine = fetchRoutineByClsSec(int.parse(value), title);
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0,left: 10.0,right: 10.0),
      child: FutureBuilder<ScheduleList>(
        future: routine,
        builder: (context,snapshot){
          print(snapshot.data);
         if(snapshot.hasData){
           if(snapshot.data.schedules.length > 0){
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(bottom:8.0),
                   child: Text(title,style:Theme.of(context).textTheme.headline6.copyWith()),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(bottom:5.0),
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Expanded(
                         child:  Text('Time',style:Theme.of(context).textTheme.headline4.copyWith()),
                       ),
                       Expanded(
                         child:  Text('Subject',style:Theme.of(context).textTheme.headline4.copyWith()),
                       ),
                       Expanded(
                         child:  Text('Room',style:Theme.of(context).textTheme.headline4.copyWith()),
                       ),
                     ],
                   ),
                 ),
                 ListView.builder(
                   physics: NeverScrollableScrollPhysics(),
                   itemCount: snapshot.data.schedules.length,
                   shrinkWrap: true,
                   itemBuilder: (context,index){
                     return RoutineRowDesign(AppFunction.getAmPm(snapshot.data.schedules[index].startTime)+'-'+AppFunction.getAmPm(snapshot.data.schedules[index].endTime),
                     snapshot.data.schedules[index].subject, snapshot.data.schedules[index].room
                     );
                   },
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top:8.0),
                   child: Container(
                     height: 0.5,
                     decoration: BoxDecoration(
                       color: Color(0xFF415094),
                     ),
                   ),
                 )
               ],
             );

               //Text(AppFunction.getAmPm(snapshot.data.schedules[0].startTime)+' - '+AppFunction.getAmPm(snapshot.data.schedules[0].endTime));

           }else{
             return Text("");
           }

         }else{
           return ShimmerList(height: 100,itemCount: 7,);
         }
        },
      ),
    );
  }

  Future<ScheduleList> fetchRoutine(dynamic id,String title) async {
    final response =
    await http.get(Uri.parse(InfixApi.getRoutineUrl(id)),headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {

      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      // print(jsonData);
      return ScheduleList.fromJson(jsonData['data'][title]);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ScheduleList> fetchRoutineByClsSec(dynamic id,String title) async {
    final response =
    await http.get(Uri.parse(InfixApi.getRoutineByClassAndSection(id,classCode,sectionCode)),headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      return ScheduleList.fromJson(jsonData['data'][title]);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

