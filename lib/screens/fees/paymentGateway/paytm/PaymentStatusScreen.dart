// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/screens/fees/widgets/fees_payment_row_widget.dart';

// ignore: must_be_immutable
class PaymentStatusScreen extends StatefulWidget {
  FeeElement fee;
  String amount;

  PaymentStatusScreen(this.fee, this.amount);

  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen>
    with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    var controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });

    controller.forward();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomPaint(
          painter: DrawCircle(_fraction),
          child: Icon(
            Icons.done,
            color: Colors.white,
            size: 50.0,
          ),
        ),
        SafeArea(child: FeePaymentRow(widget.fee)),
        SafeArea(
            child: Center(child: Text('Paid Amount : \$ ${widget.amount}'))),
        SafeArea(child: Center(child: Text('Payment successful'))),
      ],
    ));
  }
}

class DrawCircle extends CustomPainter {
  double _fraction;

  Paint _paint, _paint1;

  DrawCircle(this._fraction) {
    _paint = Paint()
      ..color = Colors.blueAccent.shade400
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;

    _paint1 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double leftLineFraction, rightLineFraction;

    if (_fraction < .5) {
      leftLineFraction = _fraction / .5;
      rightLineFraction = 0.0;
    } else {
      leftLineFraction = 1.0;
      rightLineFraction = (_fraction - .5) / .5;
    }

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        50.0 * leftLineFraction, _paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        30.0 * rightLineFraction, _paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
