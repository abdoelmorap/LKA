// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/screens/fees/controller/student_fees_controller.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/model/PaymentMethod.dart';
import 'paypal_service.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final PaymentMethod payment;
  final String fee;
  final String amount;

  PaypalPayment({this.onFinish, this.payment, this.fee, this.amount});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final StudentFeesController _studentFeesController =
      Get.put(StudentFeesController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

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

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": widget.fee,
        "quantity": 1,
        "price": widget.amount,
        "currency": '${defaultCurrency["currency"]}',
      }
    ];

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.amount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.amount,
              "tax": 0,
              "shipping": 0,
            }
          },
          "description": "${AppConfig.appName} Fee Payment of ${widget.fee}",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your payment.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print('Checkout url $checkoutUrl');

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: CustomAppBarWidget(
          title: "Paypal Payment",
        ),
        backgroundColor: Colors.white,
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((value) {
                  Map data = {
                    'id':
                        value.transactions.first.relatedResources.first.sale.id,
                    'status': value.payer.status,
                  };
                  widget.onFinish(data);
                  // Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
            }
            if (request.url.contains(cancelURL)) {
              _studentFeesController.isPaymentProcessing.value = false;
              Get.back();
              CustomSnackBar().snackBarError("Payment Cancelled".tr);
            }
            return NavigationDecision.navigate;
          },
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
