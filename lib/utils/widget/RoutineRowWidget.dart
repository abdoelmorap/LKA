// Flutter imports:
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoutineRowDesign extends StatelessWidget {
  String time;
  String subject;
  String room;

  RoutineRowDesign(
    this.time,
    this.subject,
    this.room,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(time ?? "",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              flex: 1,
              child: Text(subject ?? "",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              flex: 1,
              child: Text(room ?? "",
                  style: Theme.of(context).textTheme.headline4),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RoutineRowDesignTeacher extends StatelessWidget {
  String time;
  String subject;
  String room;
  String classRoutineClass;
  String section;

  RoutineRowDesignTeacher(this.time, this.subject, this.room,
      {this.classRoutineClass, this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(time ?? "",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              flex: 2,
              child: Text("$classRoutineClass ($section) - $subject",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              flex: 1,
              child: Text(room ?? "",
                  style: Theme.of(context).textTheme.headline4),
            ),
          ],
        ),
      ),
    );
  }
}
