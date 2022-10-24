// // Dart imports:
// import 'dart:convert';

// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;

// // Project imports:
// import 'package:infixedu/utils/FunctinsData.dart';
// import 'package:infixedu/utils/apis/Apis.dart';
// import 'package:infixedu/utils/model/TeacherMyRoutine.dart';
// import 'package:infixedu/utils/widget/ShimmerListWidget.dart';
// import '../Utils.dart';
// import 'RoutineRowWidget.dart';

// // ignore: must_be_immutable
// class TeacherRoutineRow extends StatefulWidget {
//   String title;

//   TeacherRoutineRow({this.title});

//   @override
//   _ClassRoutineState createState() => _ClassRoutineState(title);
// }

// class _ClassRoutineState extends State<TeacherRoutineRow> {
//   String title;
//   Future<TeacherMyRoutineList> routine;

//   _ClassRoutineState(this.title);
//   String _token;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     Utils.getStringValue('token').then((value) {
//       setState(() {
//         _token = value;
//       });
//       Utils.getStringValue('id').then((value) {
//         setState(() {
//           routine = fetchRoutine(int.parse(value), title);
//         });
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
//       child: FutureBuilder<TeacherMyRoutineList>(
//         future: routine,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data.schedules.length > 0) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text(title,
//                         style: Theme.of(context)
//                             .textTheme
//                             .headline6
//                             .copyWith(fontSize: ScreenUtil().setSp(15))),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Text('Time',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline4
//                                   .copyWith()),
//                         ),
//                         Expanded(
//                           child: Text('Subject',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline4
//                                   .copyWith()),
//                         ),
//                         Expanded(
//                           child: Text('Room',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline4
//                                   .copyWith()),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ListView.builder(
//                     itemCount: snapshot.data.schedules.length,
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return RoutineRowDesign(
//                           AppFunction.getAmPm(
//                                   snapshot.data.schedules[0].startTime) +
//                               ' - ' +
//                               AppFunction.getAmPm(
//                                   snapshot.data.schedules[0].endTime),
//                           snapshot.data.schedules[index].subject,
//                           snapshot.data.schedules[index].room);
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Container(
//                       height: 0.5,
//                       decoration: BoxDecoration(
//                         color: Color(0xFF415094),
//                       ),
//                     ),
//                   )
//                 ],
//               );

//               //Text(AppFunction.getAmPm(snapshot.data.schedules[0].startTime)+' - '+AppFunction.getAmPm(snapshot.data.schedules[0].endTime));
//             } else {
//               return Text("");
//             }
//           } else {
//             return ShimmerList(
//               height: 100,
//               itemCount: 7,
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<TeacherMyRoutineList> fetchRoutine(dynamic id, String title) async {
//     // print(InfixApi.getTeacherMyRoutine(id));
//     final response = await http.get(Uri.parse(InfixApi.getTeacherMyRoutine(id)),headers: Utils.setHeader(_token.toString()));
//     // print(response.body);
//     if (response.statusCode == 200) {
//       var jsonData = json.decode(response.body);
//       // If server returns an OK response, parse the JSON.
//       return TeacherMyRoutineList.fromJson(jsonData['data'][title]);
//     } else {
//       // If that response was not OK, throw an error.
//       throw Exception('Failed to load post');
//     }
//   }
// }
