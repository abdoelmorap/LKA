// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/screens/fees/paymentGateway/paytm/PaymentStatusScreen.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'package:infixedu/screens/fees/widgets/fees_payment_row_widget.dart';

// ignore: must_be_immutable
class PayPalPayment extends StatefulWidget {
  FeeElement fee;
  String id;
  String amount;
  String apiUrl = 'http://192.168.1.113:3000/';

  PayPalPayment(this.fee, this.amount, this.id);

  _PayPalPaymentState createState() => _PayPalPaymentState(amount);
}

class _PayPalPaymentState extends State<PayPalPayment> {
  String amount;

  _PayPalPaymentState(this.amount);

  final flutterWebviewPlugin = FlutterWebviewPlugin();

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

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      //print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        //print("URL changed: $url");
        if (url.contains('success')) {
          isPaymentSuccesful().then((value) {
            if (value) {
              setState(() {
                isCompleted = true;
                _onDestroy.cancel();
                _onUrlChanged.cancel();
                _onStateChanged.cancel();
                flutterWebviewPlugin.dispose();
              });
            }
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
        '?name=${widget.fee.feesName}&amount=${widget.amount}&currency=INR';

    //print(Settings.apiUrl);

    return isCompleted
        ? PaymentStatusScreen(widget.fee, amount)
        : WebviewScaffold(
            url: widget.apiUrl + queryParams,
            appBar: new AppBar(
              title: new Text("Pay using Paypal"),
            ));
  }

  Future<bool> isPaymentSuccesful() async {
    final response = await http.get(Uri.parse(InfixApi.studentFeePayment(
        widget.id,
        int.parse(widget.fee.feesTypeId.toString()),
        amount,
        widget.id,
        'Paypal')));
    var jsonData = json.decode(response.body);
    return jsonData['success'];
  }
}

// ignore: must_be_immutable
class AddPaypalAmount extends StatelessWidget {
  FeeElement fee;
  String id;
  String amount;
  TextEditingController amountController = TextEditingController();

  AddPaypalAmount(this.fee, this.id) {
    amount = '${absoluteAmount(fee.balance.toString())}';
    amountController.text = amount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Amount',
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FeePaymentRow(fee),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.headline6,
                controller: amountController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'please enter a valid amount';
                  }
                  return value;
                },
                decoration: InputDecoration(
                    hintText: "amount",
                    labelText: "amount",
                    labelStyle: Theme.of(context).textTheme.headline4,
                    errorStyle:
                        TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      ScaleRoute(
                          page: PayPalPayment(fee,
                              '${absoluteAmount(amountController.text)}', id)));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purpleAccent,
                ),
                child: Text(
                  "Enter amount",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int absoluteAmount(String am) {
    int amount = int.parse(am);
    if (amount < 0) {
      return -amount;
    } else {
      return amount;
    }
  }
}
