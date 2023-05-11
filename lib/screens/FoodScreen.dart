
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:infixedu/config/app_config.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/dailyreport.dart';

import '../utils/model/MealModel.dart';


class FoodScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FoodScreenStetes();
  }

}
class FoodScreenStetes extends State<FoodScreen>{
  Future<MealsModel> dailyReport;
  DateTime mTimeofDay;
  String _token;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: CustomAppBarWidget(title: 'FoodList'.tr),
    backgroundColor: Colors.white,
    body: Column(
    children: [
    Container(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    GestureDetector(
    child: Icon(Icons.arrow_back_ios),
    onTap: () {
    mTimeofDay = mTimeofDay.add(Duration(days: -1));
    // dailyReport = getSelectedDayData(mTimeofDay);
    setState(() {});
    },
    ),
    Text(
    "${mTimeofDay.toLocal().day}/${mTimeofDay.toLocal().month}/${mTimeofDay.toLocal().year}",
    style: TextStyle(fontSize: 24, color: Colors.white),
    ),
    GestureDetector(
    child: Icon(Icons.arrow_forward_ios),
    onTap: () {
    mTimeofDay = mTimeofDay.add(Duration(days: 1));
    // dailyReport = getSelectedDayData(mTimeofDay);
    setState(() {});
    },
    ),
    ],
    ),
    color: Color(0xFF93CFC4),
    ),
    Expanded(
    child: FutureBuilder<MealsModel>(
    future: dailyReport,
    builder: (context, snapshot) {
    if (snapshot.hasError) {
    return Container(
    child: Text(
    "Not_Available".tr,
    style: TextStyle(fontSize: 45),
    ),
    );
    }
    if (snapshot.hasData) {
    return Container(
      child: ListView.builder(itemBuilder: (ctx,index){
        return Card( child : Column(children: [
          Text(snapshot.data.data[index].title),
          Image.network(AppConfig.domainName + '/public/images/'+snapshot.data.data[index].image,height: 150,),
          Text(snapshot.data.data[index].subtitle), ],));
      },itemCount:snapshot.data.data.length ,),
    );
    } else {
    return Center(
    child: CupertinoActivityIndicator(),
    );
    }
    },
    ),
    )
    ],
    ));
    }

  Future<DailyReportModel> getSelectedDayData(DateTime mTimeofDay) async {
    var id = await Utils.getIntValue("studentId") ??
        await Utils.getIntValue("myStudentId");
    final response = await http.post(
        Uri.parse(InfixApi.getKidsStatusbyDay + "/$id"),
        headers: Utils.setHeader(_token.toString()),
        body: jsonEncode({
          "Date_Selected":
          "${mTimeofDay.month}/${mTimeofDay.day}/${mTimeofDay.year}"
        }));
    print("${mTimeofDay.month}/${mTimeofDay.day}/${mTimeofDay.year}" +
        response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData[0]);
      try {
        mTimeofDay =
            DateTime.parse(DailyReportModel.fromJson(jsonData.last).dateOfDay);

        return DailyReportModel.fromJson(jsonData.last);
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to load');
    }
  }

  Future<MealsModel> getDailyReport() async {

    final response = await http.get(
        Uri.parse(InfixApi.getKidsFoodToday ),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData[0]);
      try {
        mTimeofDay =
            DateTime.parse(MealsModel.fromJson(jsonData).data[0].dateofmeal);

        return MealsModel.fromJson(jsonData);
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to load');
    }
  }
  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
    })
      ..then((value) {
        dailyReport = getDailyReport();
      });
    mTimeofDay = DateTime.now();
  }

}
