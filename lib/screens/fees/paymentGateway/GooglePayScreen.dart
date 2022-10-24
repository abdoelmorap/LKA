// // Flutter imports:
// import 'package:flutter/material.dart';
//
//
// // Project imports:
// import 'package:infixedu/utils/CustomAppBarWidget.dart';
// import 'package:infixedu/utils/model/Fee.dart';
// import 'package:infixedu/utils/widget/buy_sheet.dart';
//
// class GooglePayScreen extends StatefulWidget {
//   final Fee fee;
//   final String id;
//
//   GooglePayScreen(this.fee, this.id);
//
//   GooglePayScreenState createState() => GooglePayScreenState();
// }
//
// class GooglePayScreenState extends State<GooglePayScreen> {
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//       statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
//     ));
//
//     return Padding(
//       padding: EdgeInsets.only(top: statusBarHeight),
//       child: Scaffold(
//           appBar: CustomAppBarWidget(
//             title: 'Google Payment',
//           ),
//           backgroundColor: Colors.white,
//           body: AddGpayAmount(widget.fee, widget.id)),
//     );
//   }
// }
