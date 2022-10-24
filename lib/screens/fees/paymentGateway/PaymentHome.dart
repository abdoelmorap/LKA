// // Flutter imports:
// import 'package:flutter/material.dart';
//
//
// // Project imports:
// import 'package:infixedu/paymentGateway/paypal/PaypalHomeScreen.dart';
// import 'package:infixedu/paymentGateway/paytm/PaytmHomeScreen.dart';
// import 'package:infixedu/utils/CustomAppBarWidget.dart';
// import 'package:infixedu/utils/Utils.dart';
// import 'package:infixedu/utils/model/Fee.dart';
// import 'package:infixedu/utils/widget/ScaleRoute.dart';
// import 'package:infixedu/utils/widget/fees_payment_row_widget.dart';
// import 'GooglePayScreen.dart';
// import 'RazorPay/RazorPayHome.dart';
//
// class PaymentHome extends StatefulWidget {
//   final Fee fee;
//   final String id;
//
//   PaymentHome(this.fee, this.id);
//
//   @override
//   _PaymentHomeState createState() => _PaymentHomeState();
// }
//
// class _PaymentHomeState extends State<PaymentHome> {
//   String _email;
//
//   @override
//   void initState() {
//     Utils.getStringValue('email').then((value) {
//       _email = value;
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//       statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
//     ));
//
//     return Padding(
//       padding: EdgeInsets.only(top: statusBarHeight),
//       child: Scaffold(
//         appBar: CustomAppBarWidget(
//           title: 'Payment',
//         ),
//         backgroundColor: Colors.white,
//         body: ListView(
//           children: <Widget>[
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context, ScaleRoute(page: AddAmount(widget.fee, _email)));
//               },
//               child: Card(
//                 elevation: 4.0,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 25.0,
//                     backgroundColor: Colors.black12,
//                     child: Image.asset('assets/images/paytm.png'),
//                   ),
//                   title: Text(
//                     'Paytm',
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline5
//                         .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context,
//                     ScaleRoute(page: AddPaypalAmount(widget.fee, widget.id)));
//               },
//               child: Card(
//                 elevation: 4.0,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 25.0,
//                     backgroundColor: Colors.black12,
//                     child: Image.asset('assets/images/paypal.png'),
//                   ),
//                   title: Text(
//                     'Paypal',
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline5
//                         .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context,
//                     ScaleRoute(page: GooglePayScreen(widget.fee, widget.id)));
//               },
//               child: Card(
//                 elevation: 4.0,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 25.0,
//                     backgroundColor: Colors.orangeAccent,
//                     child: Image.asset('assets/images/googleplay.png'),
//                   ),
//                   title: Text(
//                     'GPay',
//                     style: Theme.of(context).textTheme.headline5.copyWith(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 18,
//                         color: Colors.redAccent),
//                   ),
//                 ),
//               ),
//             ),
// //            GestureDetector(
// //              onTap: () {
// //                Navigator.push(
// //                    context, ScaleRoute(page: GooglePayScreen(widget.fee)));
// //              },
// //              child: Card(
// //                elevation: 4.0,
// //                child: ListTile(
// //                  leading: CircleAvatar(
// //                    radius: 25.0,
// //                    backgroundColor: Colors.greenAccent,
// //                    child: Image.asset('assets/images/payumoney.png'),
// //                  ),
// //                  title: Text(
// //                    'PayUMoney',
// //                    style: Theme.of(context).textTheme.headline.copyWith(
// //                        fontWeight: FontWeight.w700,
// //                        fontSize: 18,
// //                        color: Colors.green),
// //                  ),
// //                ),
// //              ),
// //            ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context,
//                     ScaleRoute(page: RazorPayment(widget.fee, widget.id)));
//               },
//               child: Card(
//                 elevation: 4.0,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 25.0,
//                     backgroundColor: Colors.blueAccent,
//                     child: Image.asset('assets/images/razorpay.jpeg'),
//                   ),
//                   title: Text(
//                     'Razorpay',
//                     style: Theme.of(context).textTheme.headline5.copyWith(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 18,
//                         color: Colors.blue),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ignore: must_be_immutable
// class AddAmount extends StatelessWidget {
//   final Fee fee;
//   String amount;
//   String email;
//   TextEditingController amountController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   AddAmount(this.fee, this.email) {
//     amount = '${absoluteAmount(fee.balance)}';
//     amountController.text = amount;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//       statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
//     ));
//
//     return Padding(
//       padding: EdgeInsets.only(top: statusBarHeight),
//       child: Scaffold(
//         appBar: CustomAppBarWidget(
//           title: 'Amount',
//         ),
//         backgroundColor: Colors.white,
//         body: Container(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: FeePaymentRow(fee),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: TextFormField(
//                     keyboardType: TextInputType.numberWithOptions(
//                         decimal: false, signed: false),
//                     style: Theme.of(context).textTheme.headline6,
//                     controller: amountController,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (String value) {
//                       RegExp regExp = new RegExp(r'^[0-9]*$');
//                       if (value.isEmpty) {
//                         return 'Please enter a valid amount';
//                       }
//                       if (!regExp.hasMatch(value)) {
//                         return 'Please enter a number';
//                       }
//                       if (int.tryParse(value) > int.tryParse(fee.balance)) {
//                         return 'Amount must not greater than balance';
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       hintText: "Amount",
//                       labelText: "Amount",
//                       labelStyle: Theme.of(context).textTheme.headline4,
//                       errorStyle:
//                           TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState.validate()) {
//                         Navigator.push(
//                             context,
//                             ScaleRoute(
//                                 page: PaytmPayment(
//                                     fee,
//                                     '${absoluteAmount(amountController.text)}',
//                                     email)));
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.purpleAccent,
//                     ),
//                     child: Text(
//                       "Continue",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline5
//                           .copyWith(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   int absoluteAmount(String am) {
//     int amount = int.parse(am);
//     if (amount < 0) {
//       return -amount;
//     } else {
//       return amount;
//     }
//   }
// }
