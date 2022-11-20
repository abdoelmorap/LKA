// Flutter imports:
import 'package:flutter/material.dart';

class CookieButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CookieButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
      height: 64,
      width: MediaQuery.of(context).size.width * .4,
      child: ElevatedButton(
        child: FittedBox(
            child: Text(text,
                style: TextStyle(color: Colors.white, fontSize: 18))),
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurpleAccent,
        ),
        onPressed: onPressed,
      ));
}
