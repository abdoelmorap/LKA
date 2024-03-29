
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
  Future<MealsModel>? dailyReport;
  late DateTime mTimeofDay;
  String? _token;
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
     dailyReport = getSelectedDayData(mTimeofDay);
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
    dailyReport = getSelectedDayData(mTimeofDay);
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
    if (snapshot.hasError||snapshot.hasData.isNull) {
    return Center(
    child: Text(
    "Not_Available".tr,
    style: TextStyle(fontSize: 45),
    ),
    );
    }
    if (snapshot.hasData) {
    return Container(
      child: ListView.builder(itemBuilder: (ctx,index){
        return Card( child :
        Row(children: [
          Image.network(AppConfig.domainName + '/public/images/'+snapshot.data!.data![index].image!,height: 120 ,width: 120,)
,SizedBox(width: 20,),
          Column(children: [
           Row(children: [
             Text(
               "Meal Name: ",

              style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromARGB(255, 56, 51, 51)              ),
               textAlign: TextAlign.start,),
             Text(

                   snapshot.data!.data![index].title!,  style: const TextStyle(
               fontSize: 16.0,
               color: Colors.grey,
             ),
               textAlign: TextAlign.start,),
           ],),
            SizedBox(child:RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Meal Description: ', style: const TextStyle(color: Color.fromARGB(255, 56, 51, 51) ,fontWeight: FontWeight.bold)),
                  TextSpan(text:  snapshot.data!.data![index].subtitle),
                ],
              ),
            ), width: 230, ),
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Meal Time: ', style: const TextStyle(color: Color.fromARGB(255, 56, 51, 51) ,fontWeight: FontWeight.bold)),
                  TextSpan(text:   (snapshot.data!.data![index].orderMeal==0?"N/A":
                  snapshot.data!.data![index].orderMeal==1?"BreakFast":
                  snapshot.data!.data![index].orderMeal==2?"Lunch":
                  snapshot.data!.data![index].orderMeal==3?"Snacks":"N/A")),
                ],
              ),
            ),



     ]  ,crossAxisAlignment: CrossAxisAlignment.start)



        ],)
       );
      },itemCount:snapshot.data!.data!.length ,),
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

  Future<MealsModel> getSelectedDayData(DateTime mTimeofDay) async {
    var id = await Utils.getIntValue("studentId") ??
        await Utils.getIntValue("myStudentId");
    final response = await http.post(
        Uri.parse(InfixApi.getfoodbyDay),
        headers: Utils.setHeader(_token.toString()),
        body: jsonEncode({
          "Date_Selected":
          "${mTimeofDay.month}/${mTimeofDay.day}/${mTimeofDay.year}"
        }));
    print("${mTimeofDay.month}/${mTimeofDay.day}/${mTimeofDay.year}" +
        response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print( MealsModel.fromJson(jsonData).data!.isEmpty);
 if( MealsModel.fromJson(jsonData).data!.length == 0){
  return Future.error(0);
 }
      try {
        mTimeofDay =
            DateTime.parse(MealsModel.fromJson(jsonData).data![0].dateofmeal!);

        return MealsModel.fromJson(jsonData);
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to load');
    }
    throw'';
  }

  Future<MealsModel> getDailyReport() async {

    final response = await http.get(
        Uri.parse(InfixApi.getKidsFoodToday ),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print( MealsModel.fromJson(jsonData).data!.isEmpty);
      if( MealsModel.fromJson(jsonData).data!.length == 0){
        return Future.error(0);
      }
      try {
        mTimeofDay =
            DateTime.parse(MealsModel.fromJson(jsonData).data![0].dateofmeal!);
        if( MealsModel.fromJson(jsonData).data!.length == 0){
          print( MealsModel.fromJson(jsonData).data!.length);
          throw  '';
        }
        return MealsModel.fromJson(jsonData);
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to load');
    }

    throw'';
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
