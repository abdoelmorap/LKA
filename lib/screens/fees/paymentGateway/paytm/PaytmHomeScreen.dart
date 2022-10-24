// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'PaymentStatusScreen.dart';
import 'settings.dart';

// import 'dart:math';

class PaytmPayment extends StatefulWidget {
  final FeeElement fee;
  final String amount;
  final String email;

  PaytmPayment(this.fee, this.amount, this.email);

  _PaytmPaymentState createState() => _PaytmPaymentState(amount);
}

class _PaytmPaymentState extends State<PaytmPayment> {
  String amount;
  bool isGet = false;

  _PaytmPaymentState(this.amount);

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  // static Random seed = Random();
  // static int val = seed.nextInt(100000);
  static int val = DateTime.now().millisecondsSinceEpoch;
  final orderId = 'INFIX_$val';
  final customerId = '$val';
  String email = '';
  String id = '';

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  var isCompleted = false;

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    print(orderId);

    this.email = widget.email;

    Utils.getStringValue('id').then((value) {
      id = value;
    });

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("URL changed: $url");

        if (url.endsWith('request1.jsp')) {
          setState(() {
            isGet = true;
          });
        }

        if (url.contains('callback') && isGet) {
          flutterWebviewPlugin.getCookies().then((cookies) {
            print("cookies $cookies");
            print('TXNID $cookies["TXNID"]');
            print('STATUS $cookies["STATUS"]');
            print('RESPCODE $cookies["RESPCODE"]');
            print('RESPMSG $cookies["RESPMSG"]');
            print('TXNDATE $cookies["TXNDATE"]');

            isPaymentSuccesful().then((value) {
              if (value) {
                setState(() {
                  isCompleted = true;
                  isGet = false;
                  flutterWebviewPlugin.close();
                });
              }
            });
          });
        } else {
          setState(() {
            isCompleted = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryParams =
        '?order_id=$orderId&customer_id=$customerId&amount=$amount&email=$email';

    //print(Settings.apiUrl);

    return isCompleted
        ? PaymentStatusScreen(widget.fee, amount)
        : WebviewScaffold(
            url: Settings.apiUrl + queryParams,
            appBar: new AppBar(
              title: new Text("Pay using PayTM"),
            ));
  }

  Future<bool> isPaymentSuccesful() async {
    print('${widget.fee.feesTypeId}');
    final response = await http.get(Uri.parse(InfixApi.studentFeePayment(
        id, int.parse(widget.fee.feesTypeId.toString()), amount, id, 'PayTm')));
    var jsonData = json.decode(response.body);
    print('PPAYMENT: $jsonData');
    return jsonData['success'];
  }
}
