// // Dart imports:
// import 'dart:async';
// import 'dart:io';
//
// // Flutter imports:
// import 'package:flutter/material.dart';
//
//
// // Package imports:
// import 'package:square_in_app_payments/in_app_payments.dart';
// import 'package:square_in_app_payments/models.dart';
// import 'package:uuid/uuid.dart';
//
// // Project imports:
// import 'package:infixedu/paymentGateway/transaction_service.dart';
// import 'package:infixedu/utils/CustomAppBarWidget.dart';
// import 'package:infixedu/utils/Utils.dart';
// import 'package:infixedu/utils/apis/Config.dart';
// import 'package:infixedu/utils/model/Fee.dart';
// import 'ScaleRoute.dart';
// import 'dialog_modal.dart';
// import 'fees_payment_row_widget.dart';
// import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
// import 'order_sheet.dart';
//
// import 'package:square_in_app_payments/google_pay_constants.dart'
//     as google_pay_constants;
//
//
// enum ApplePayStatus { success, fail, unknown }
//
// // ignore: must_be_immutable
// class BuySheet extends StatefulWidget {
//   Fee fee;
//   String id;
//   String amount;
//   final bool applePayEnabled;
//   final bool googlePayEnabled;
//   final String squareLocationId;
//   final String applePayMerchantId;
//   static final GlobalKey<ScaffoldState> scaffoldKey =
//       GlobalKey<ScaffoldState>();
//
//   BuySheet(
//       {this.applePayEnabled,
//       this.googlePayEnabled,
//       this.applePayMerchantId,
//       this.squareLocationId,
//       this.fee,
//       this.id,
//       this.amount});
//
//   @override
//   BuySheetState createState() => BuySheetState();
// }
//
// class BuySheetState extends State<BuySheet> {
//   ApplePayStatus _applePayStatus = ApplePayStatus.unknown;
//
//   bool get _chargeServerHostReplaced => chargeServerHost != "REPLACE_ME";
//
//   bool get _squareLocationSet => widget.squareLocationId == "LJNYT2X3K64SH";
//
//   bool get _applePayMerchantIdSet => widget.applePayMerchantId != "REPLACE_ME";
//
//   void _showOrderSheet() async {
//     var selection =
//         await custom_modal_bottom_sheet.showModalBottomSheet<PaymentType>(
//             context: BuySheet.scaffoldKey.currentState.context,
//             builder: (context) => OrderSheet(
//                   email: email,
//                   balance: widget.amount,
//                   applePayEnabled: widget.applePayEnabled,
//                   googlePayEnabled: widget.googlePayEnabled,
//                 ));
//
//     switch (selection) {
//       case PaymentType.cardPayment:
//         // call _onStartCardEntryFlow to start Card Entry without buyer verification (SCA)
//         await _onStartCardEntryFlow();
//         // OR call _onStartCardEntryFlowWithBuyerVerification to start Card Entry with buyer verification (SCA)
//         // NOTE this requires _squareLocationSet to be set
//         // await _onStartCardEntryFlowWithBuyerVerification();
//         break;
//       case PaymentType.googlePay:
//         if (_squareLocationSet && widget.googlePayEnabled) {
//           _onStartGooglePay();
//         } else {
//           _showSquareLocationIdNotSet();
//         }
//         break;
//       case PaymentType.applePay:
//         if (_applePayMerchantIdSet && widget.applePayEnabled) {
//           _onStartApplePay();
//         } else {
//           _showapplePayMerchantIdNotSet();
//         }
//         break;
//     }
//     print("AA $_squareLocationSet");
//     print(widget.googlePayEnabled);
//   }
//
//   void printCurlCommand(String nonce, String verificationToken) {
//     var hostUrl = 'https://connect.squareup.com';
//     if (squareApplicationId.startsWith('sandbox')) {
//       hostUrl = 'https://connect.squareupsandbox.com';
//     }
//     var uuid = Uuid().v4();
//
//     if (verificationToken == null) {
//       print(
//           'curl --request POST $hostUrl/v2/locations/SQUARE_LOCATION_ID/transactions \\'
//           '--header \"Content-Type: application/json\" \\'
//           '--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\'
//           '--header \"Accept: application/json\" \\'
//           '--data \'{'
//           '\"idempotency_key\": \"$uuid\",'
//           '\"amount_money\": {'
//           '\"amount\": ${widget.amount},'
//           '\"currency\": \"USD\"},'
//           '\"card_nonce\": \"$nonce\"'
//           '}\'');
//     } else {
//       print('curl --request POST $hostUrl/v2/payments \\'
//           '--header \"Content-Type: application/json\" \\'
//           '--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\'
//           '--header \"Accept: application/json\" \\'
//           '--data \'{'
//           '\"idempotency_key\": \"$uuid\",'
//           '\"amount_money\": {'
//           '\"amount\": ${widget.amount},'
//           '\"currency\": \"USD\"},'
//           '\"source_id\": \"$nonce\",'
//           '\"verification_token\": \"$verificationToken\"'
//           '}\'');
//     }
//   }
//
//   void _showUrlNotSetAndPrintCurlCommand(String nonce,
//       {String verificationToken}) {
//     String title;
//     if (verificationToken != null) {
//       title = "Nonce and verification token generated but not charged";
//     } else {
//       title = "Nonce generated but not charged";
//     }
//     showAlertDialog(
//         context: BuySheet.scaffoldKey.currentContext,
//         title: title,
//         description:
//             "Check your console for a CURL command to charge the nonce, or replace CHARGE_SERVER_HOST with your server host.");
//     printCurlCommand(nonce, verificationToken);
//   }
//
//   void _showSquareLocationIdNotSet() {
//     showAlertDialog(
//         context: BuySheet.scaffoldKey.currentContext,
//         title: "Missing Square Location ID",
//         description:
//             "To request a Google Pay nonce, replace squareLocationId in main.dart with a Square Location ID.");
//   }
//
//   void _showapplePayMerchantIdNotSet() {
//     showAlertDialog(
//         context: BuySheet.scaffoldKey.currentContext,
//         title: "Missing Apple Merchant ID",
//         description:
//             "To request an Apple Pay nonce, replace applePayMerchantId in main.dart with an Apple Merchant ID.");
//   }
//
//   void _onCardEntryComplete() {
//     if (_chargeServerHostReplaced) {
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Your order was successful",
//           description:
//               "Go to your Square dashbord to see this order reflected in the sales tab.");
//     }
//   }
//
//   void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
//     if (!_chargeServerHostReplaced) {
//       InAppPayments.completeCardEntry(
//           onCardEntryComplete: _onCardEntryComplete);
//       _showUrlNotSetAndPrintCurlCommand(result.nonce);
//       return;
//     }
//     try {
//       await chargeCard(result, widget.amount, widget.id, widget.fee, context);
//       InAppPayments.completeCardEntry(
//           onCardEntryComplete: _onCardEntryComplete);
//     } on ChargeException catch (ex) {
//       InAppPayments.showCardNonceProcessingError(ex.errorMessage);
//     }
//   }
//
//   Future<void> _onStartCardEntryFlow() async {
//     await InAppPayments.startCardEntryFlow(
//         onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
//         onCardEntryCancel: _onCancelCardEntryFlow,
//         collectPostalCode: true);
//   }
//
// //  Future<void> _onStartCardEntryFlowWithBuyerVerification() async {
// //    var money = Money((b) => b
// //      ..amount = 100
// //      ..currencyCode = 'USD');
// //
// //    var contact = Contact((b) => b
// //      ..givenName = "John"
// //      ..familyName = "Doe"
// //      ..addressLines =
// //          new BuiltList<String>(["London Eye", "Riverside Walk"]).toBuilder()
// //      ..city = "London"
// //      ..countryCode = "GB"
// //      ..email = "johndoe@example.com"
// //      ..phone = "8001234567"
// //      ..postalCode = "SE1 7");
// //
// //    await InAppPayments.startCardEntryFlowWithBuyerVerification(
// //        onBuyerVerificationSuccess: _onBuyerVerificationSuccess,
// //        onBuyerVerificationFailure: _onBuyerVerificationFailure,
// //        onCardEntryCancel: _onCancelCardEntryFlow,
// //        buyerAction: "Charge",
// //        money: money,
// //        squareLocationId: squareLocationId,
// //        contact: contact,
// //        collectPostalCode: true);
// //  }
//
//   void _onCancelCardEntryFlow() {
//     _showOrderSheet();
//   }
//
//   void _onStartGooglePay() async {
//     try {
//       await InAppPayments.requestGooglePayNonce(
//           priceStatus: google_pay_constants.totalPriceStatusFinal,
//           price: widget.amount,
//           currencyCode: 'USD',
//           onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
//           onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
//           onGooglePayCanceled: onGooglePayEntryCanceled);
//     } on PlatformException catch (ex) {
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Failed to start GooglePay",
//           description: ex.toString());
//     }
//   }
//
//   void _onGooglePayNonceRequestSuccess(CardDetails result) async {
//     if (!_chargeServerHostReplaced) {
//       _showUrlNotSetAndPrintCurlCommand(result.nonce);
//       return;
//     }
//     try {
//       await chargeCard(result, widget.amount, widget.id, widget.fee, context);
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Your order was successful",
//           description:
//               "Go to your Square dashbord to see this order reflected in the sales tab.");
//     } on ChargeException catch (ex) {
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Error processing GooglePay payment",
//           description: ex.errorMessage);
//     }
//   }
//
//   void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
//     showAlertDialog(
//         context: BuySheet.scaffoldKey.currentContext,
//         title: "Failed to request GooglePay nonce",
//         description: errorInfo.toString());
//   }
//
//   void onGooglePayEntryCanceled() {
//     _showOrderSheet();
//   }
//
//   void _onStartApplePay() async {
//     try {
//       await InAppPayments.requestApplePayNonce(
//           price: widget.amount,
//           summaryLabel: 'Cookie',
//           countryCode: 'US',
//           currencyCode: 'USD',
//           paymentType: ApplePayPaymentType.finalPayment,
//           onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
//           onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
//           onApplePayComplete: _onApplePayEntryComplete);
//     } on PlatformException catch (ex) {
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Failed to start ApplePay",
//           description: ex.toString());
//     }
//   }
//
//   void _onApplePayNonceRequestSuccess(CardDetails result) async {
//     if (!_chargeServerHostReplaced) {
//       await InAppPayments.completeApplePayAuthorization(isSuccess: false);
//       _showUrlNotSetAndPrintCurlCommand(result.nonce);
//       return;
//     }
//     try {
//       await chargeCard(result, widget.amount, widget.id, widget.fee, context);
//       _applePayStatus = ApplePayStatus.success;
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Your order was successful",
//           description:
//               "Go to your Square dashbord to see this order reflected in the sales tab.");
//       await InAppPayments.completeApplePayAuthorization(isSuccess: true);
//     } on ChargeException catch (ex) {
//       await InAppPayments.completeApplePayAuthorization(
//           isSuccess: false, errorMessage: ex.errorMessage);
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Error processing ApplePay payment",
//           description: ex.errorMessage);
//       _applePayStatus = ApplePayStatus.fail;
//     }
//   }
//
//   void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
//     _applePayStatus = ApplePayStatus.fail;
//     await InAppPayments.completeApplePayAuthorization(
//         isSuccess: false, errorMessage: errorInfo.message);
//     showAlertDialog(
//         context: BuySheet.scaffoldKey.currentContext,
//         title: "Error request ApplePay nonce",
//         description: errorInfo.toString());
//   }
//
//   void _onApplePayEntryComplete() {
//     if (_applePayStatus == ApplePayStatus.unknown) {
//       // the apple pay is canceled
//       _showOrderSheet();
//     }
//   }
//
//   void onBuyerVerificationSuccess(BuyerVerificationDetails result) async {
//     if (!_chargeServerHostReplaced) {
//       _showUrlNotSetAndPrintCurlCommand(result.nonce,
//           verificationToken: result.token);
//       return;
//     }
//
//     try {
//       await chargeCardAfterBuyerVerification(result);
//     } on ChargeException catch (ex) {
//       showAlertDialog(
//           context: BuySheet.scaffoldKey.currentContext,
//           title: "Error processing card payment",
//           description: ex.errorMessage);
//     }
//   }
//
//   void onBuyerVerificationFailure(ErrorInfo errorInfo) async {
//     showAlertDialog(
//         context: BuySheet.scaffoldKey.currentContext,
//         title: "Error verifying buyer",
//         description: errorInfo.toString());
//   }
//
//   String email = '';
//   @override
//   void initState() {
//     Utils.getStringValue('email').then((value) {
//       email = value;
//     });
//     super.initState();
//   }
//
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//       statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
//     ));
//
//     return Padding(
//       padding: EdgeInsets.only(top: statusBarHeight),
//       child: Scaffold(
//         // appBar: CustomAppBarWidget(title: 'GPay Payment'),
//         appBar: CustomAppBarWidget(
//           title: 'GPay Payment',
//         ),
//         key: BuySheet.scaffoldKey,
//         body: Builder(
//           builder: (context) => Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 child: FeePaymentRow(widget.fee),
//               ),
//               Container(
//                 child: Image(image: AssetImage("assets/images/about.png")),
//               ),
//               Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Check your amount of fee  \nwhen you make payment",
//                     style: Theme.of(context).textTheme.headline4,
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Amount to Pay : ${widget.amount} \$",
//                     style: Theme.of(context).textTheme.headline3,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _showOrderSheet();
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(top: 32),
//                   child: Container(
//                     height: 40.0,
//                     margin: EdgeInsets.symmetric(horizontal: 20.0),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Make Payment',
//                         style: Theme.of(context)
//                             .textTheme
//                             .headline4
//                             .copyWith(color: Colors.white),
//                       ),
//                     ),
// //                onPressed: openCheckout,
//                   ),
//                 ),
//               ),
//             ],
//           )),
//         ),
//       ),
//     );
//   }
// }
//
// // ignore: must_be_immutable
// class AddGpayAmount extends StatefulWidget {
//   Fee fee;
//   String id;
//
//   AddGpayAmount(this.fee, this.id);
//
//   @override
//   _AddGpayAmountState createState() => _AddGpayAmountState(fee, id);
// }
//
// class _AddGpayAmountState extends State<AddGpayAmount> {
//   Fee fee;
//   String amount;
//   String id;
//   bool isLoading = true;
//   bool applePayEnabled = false;
//   bool googlePayEnabled = false;
//   TextEditingController amountController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   // static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(); //TODO:: test buy sheet
//
//   _AddGpayAmountState(this.fee, this.id) {
//     amount = '${absoluteAmount(fee.balance)}';
//     amountController.text = amount;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initSquarePayment();
//
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   }
//
//   Future<void> _initSquarePayment() async {
//     await InAppPayments.setSquareApplicationId(squareApplicationId);
//
//     var canUseApplePay = false;
//     var canUseGooglePay = false;
//     if (Platform.isAndroid) {
//       await InAppPayments.initializeGooglePay(
//           squareLocationId, google_pay_constants.environmentTest);
//       canUseGooglePay = await InAppPayments.canUseGooglePay;
//     } else if (Platform.isIOS) {
//       await _setIOSCardEntryTheme();
//       await InAppPayments.initializeApplePay(applePayMerchantId);
//       canUseApplePay = await InAppPayments.canUseApplePay;
//     }
//
//     setState(() {
//       isLoading = false;
//       applePayEnabled = canUseApplePay;
//       googlePayEnabled = canUseGooglePay;
//     });
//   }
//
//   Future _setIOSCardEntryTheme() async {
//     var themeConfiguationBuilder = IOSThemeBuilder();
//     themeConfiguationBuilder.saveButtonTitle = 'Pay';
//     themeConfiguationBuilder.errorColor = RGBAColorBuilder()
//       ..r = 255
//       ..g = 0
//       ..b = 0;
//     themeConfiguationBuilder.tintColor = RGBAColorBuilder()
//       ..r = 36
//       ..g = 152
//       ..b = 141;
//     themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
//     themeConfiguationBuilder.messageColor = RGBAColorBuilder()
//       ..r = 114
//       ..g = 114
//       ..b = 114;
//
//     await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
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
//                         signed: false, decimal: false),
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
//                         hintText: "Amount",
//                         labelText: "Amount",
//                         labelStyle: Theme.of(context).textTheme.headline4,
//                         errorStyle:
//                             TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         )),
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
//                                 page: BuySheet(
//                               fee: widget.fee,
//                               applePayEnabled: applePayEnabled,
//                               googlePayEnabled: googlePayEnabled,
//                               applePayMerchantId: applePayMerchantId,
//                               squareLocationId: squareLocationId,
//                               id: widget.id,
//                               amount: amountController.text,
//                             )));
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
// //  void _handlePaymentSuccess(PaymentSuccessResponse response) {
// //    Fluttertoast.showToast(
// //        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
// //
// //    isPaymentSuccesful().then((value) {
// //      if (value) {
// //        Navigator.push(
// //            context,
// //            ScaleRoute(
// //                page: PaymentStatusScreen(widget.fee, amountController.text)));
// //      }
// //    });
// //  }
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
