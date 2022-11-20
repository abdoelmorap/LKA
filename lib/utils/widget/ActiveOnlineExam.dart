// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:infixedu/utils/model/ActiveOnlineExam.dart';

// ignore: must_be_immutable
class ActiveOnlineExamRow extends StatelessWidget {
  ActiveOnlineExam exam;

  ActiveOnlineExamRow(this.exam);

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  exam.title == null ? 'not assigned' : exam.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: ScreenUtil().setSp(15.0)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Subject',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        exam.subject == null ? 'N/A' : exam.subject,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        exam.date == null ? 'N/A' : exam.date,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Action',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      getStatus(context, exam.isRunning, exam.isClosed,
                          exam.isWaiting),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.purple, Colors.deepPurple]),
            ),
          ),
        ],
      ),
    );
  }

  Widget getExamStatusWidget(
      {BuildContext context,
      dynamic isRunning,
      dynamic isWaiting,
      dynamic isClosed}) {
    if (isRunning == 1) {
      return Text(
        'Running',
        textAlign: TextAlign.center,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
      );
    } else if (isWaiting == 1) {
      return Text(
        'Pending',
        textAlign: TextAlign.center,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
      );
    } else if (isClosed == 1) {
      return Text(
        'Closed',
        textAlign: TextAlign.center,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
      );
    } else {
      return Text(
        'not assigned',
        textAlign: TextAlign.center,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
      );
    }
  }

  getStatus(BuildContext context, dynamic isRunning, dynamic isClosed,
      dynamic isWaiting) {
    if (isClosed == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.indigo.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Closed',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (isRunning == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.indigo.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Running',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (isWaiting == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.red.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Waiting',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 30,
      );
    }
  }
}
