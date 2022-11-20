// // Dart imports:
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// // Flutter imports:
// import 'package:flutter/cupertino.dart';
//
// // Package imports:
// import 'package:http/http.dart' as http;
// import 'package:square_in_app_payments/models.dart';
//
// // Project imports:
// import 'package:infixedu/paymentGateway/paytm/PaymentStatusScreen.dart';
// import 'package:infixedu/utils/apis/Apis.dart';
// import 'package:infixedu/utils/model/Fee.dart';
// import 'package:infixedu/utils/widget/ScaleRoute.dart';
//
// // Replace this with the server host you create, if you have your own server running
// // e.g. https://server-host.com
// String chargeServerHost = "https://infixed.herokuapp.com";
// String chargeUrl = "$chargeServerHost/chargeForCookie";
//
// class ChargeException implements Exception {
//   String errorMessage;
//
//   ChargeException(this.errorMessage);
// }
//
// Future<void> chargeCard(CardDetails result, String amount, String id, Fee fee,
//     BuildContext context) async {
//   var body = jsonEncode({"nonce": result.nonce});
//   http.Response response;
//   try {
//     response = await http.post(Uri.parse(chargeUrl), body: body, headers: {
//       "Accept": "application/json",
//       "content-type": "application/json"
//     });
//   } on SocketException catch (ex) {
//     throw ChargeException(ex.message);
//   }
//
//   var responseBody = json.decode(response.body);
//   if (response.statusCode == 200) {
//     isPaymentSuccesful(amount, id, fee,context);
//     return;
//   } else {
//     throw ChargeException(responseBody["errorMessage"]);
//   }
// }
//
// Future<void> chargeCardAfterBuyerVerification(
//     BuyerVerificationDetails result) async {
//   var body = jsonEncode({"nonce": result.nonce, "token": result.token});
//   http.Response response;
//   try {
//     response = await http.post(Uri.parse(chargeUrl), body: body, headers: {
//       "Accept": "application/json",
//       "content-type": "application/json"
//     });
//   } on SocketException catch (ex) {
//     throw ChargeException(ex.message);
//   }
//
//   var responseBody = json.decode(response.body);
//   if (response.statusCode == 200) {
//     return;
//   } else {
//     throw ChargeException(responseBody["errorMessage"]);
//   }
// }
//
// Future<bool> isPaymentSuccesful(String amount, String id, Fee fee,BuildContext context) async {
//   final response =
//       await http.get(Uri.parse(InfixApi.studentFeePayment(id, fee.id, amount, id, 'C')));
//   var jsonData = json.decode(response.body);
//   if(response.statusCode == 200){
//     Navigator.push(
//         context, ScaleRoute(page: PaymentStatusScreen(fee, amount)));
//   }
//   return jsonData['success'];
// }
