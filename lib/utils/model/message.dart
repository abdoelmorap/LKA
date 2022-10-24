// Flutter imports:
import 'package:flutter/cupertino.dart';

@immutable
class Message {
  final String title;
  final String body;

  Message({
    @required this.title,
    @required this.body,
  });
}
