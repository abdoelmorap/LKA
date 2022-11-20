// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'cookie_button.dart';

enum PaymentType { cardPayment, googlePay, applePay }

class OrderSheet extends StatelessWidget {
  final bool googlePayEnabled;
  final bool applePayEnabled;
  final String balance;
  final String email;

  OrderSheet({this.balance, this.googlePayEnabled, this.applePayEnabled,this.email});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: _headline6(context),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: 300,
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _ShippingInformation(email: email,),
                      _LineDivider(),
                      _PaymentTotal(double.parse(balance)),
                      _LineDivider(),
                      _RefundInformation(),
                      _payButtons(context),
                    ]),
              ),
            ]),
      );

  Widget _headline6(context) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                color: Colors.black)),
        Container(
          child: Expanded(
            child: Text(
              "Place your payment",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 56)),
      ]);

  Widget _payButtons(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CookieButton(
            text: "Pay with card",
            onPressed: () {
              Navigator.pop(context, PaymentType.cardPayment);
            },
          ),
          Container(
            height: 64,
            width: MediaQuery.of(context).size.width * .4,
            child: ElevatedButton(
              onPressed: googlePayEnabled || applePayEnabled
                  ? () {
                      if (Platform.isAndroid) {
                        Navigator.pop(context, PaymentType.googlePay);
                      } else if (Platform.isIOS) {
                        Navigator.pop(context, PaymentType.applePay);
                      }
                    }
                  : null,
              child: Image(
                  image: Platform.isIOS
                      ? AssetImage("assets/images/applePayLogo.png")
                      : AssetImage("assets/images/googlePayLogo.png")),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent,
              ),
            ),
          ),
        ],
      );
}

class _ShippingInformation extends StatelessWidget {
  final String email;
  _ShippingInformation({this.email});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Ship to",
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  email,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                ),
                // Text(
                //   "Dhaka\nBangladesh",
                //   style: Theme.of(context).textTheme.headline4,
                // ),
              ]),
        ],
      );
}

class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Divider(
        height: 1,
        color: Colors.deepPurpleAccent,
      ));
}

class _PaymentTotal extends StatelessWidget {
  final double balance;

  _PaymentTotal(this.balance);

  String getCookieAmount() => (balance / 100).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Total",
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(padding: EdgeInsets.only(right: 47)),
          Text(
            "\$$balance",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class _RefundInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: MediaQuery.of(context).size.width - 60,
              child: Text(
                "You can refund this transaction through your Square dashboard, go to squareup.com/dashboard.",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      );
}
