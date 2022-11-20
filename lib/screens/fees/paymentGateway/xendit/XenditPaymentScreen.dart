// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/utils/model/PaymentMethod.dart';

class XenditPaymentScreen extends StatefulWidget {
  final Function onFinish;
  final PaymentMethod payment;
  final FeeElement fee;
  final String amount;
  final String redirectUrl;
  final String authenticationId;

  XenditPaymentScreen(
      {this.onFinish,
      this.payment,
      this.fee,
      this.amount,
      this.redirectUrl,
      this.authenticationId});

  @override
  State<StatefulWidget> createState() {
    return XenditPaymentScreenState();
  }
}

class XenditPaymentScreenState extends State<XenditPaymentScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "$paypalCurrency ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": paypalCurrency
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Checkout url ${widget.redirectUrl}');

    if (widget.redirectUrl != null) {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: "Xendit Payment",
          ),
          backgroundColor: Colors.white,
          body: WebView(
            initialUrl: widget.redirectUrl,
            javascriptMode: JavascriptMode.unrestricted,
            userAgent: 'Flutter;Webview',
            navigationDelegate: (NavigationRequest request) {
              print(request.url);
              if (request.url ==
                  "https://redirect.xendit.co/callbacks/authentications/cybs/bundled/${widget.authenticationId}?api_key=$xenditPublicKey") {
                print('matched');
                Future.delayed(Duration(seconds: 3), () {
                  widget.onFinish(widget.authenticationId);
                  Navigator.of(context).pop();
                });
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
