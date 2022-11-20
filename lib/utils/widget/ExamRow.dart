// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/utils/model/ClassExamList.dart';
import '../FunctinsData.dart';

// ignore: must_be_immutable
class StudentExamRow extends StatelessWidget {

  Exam exam;


  StudentExamRow(this.exam);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Exam: ',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  exam.examName,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Subject: ',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                  '${exam.subjectName == null ? 'N/A':exam.subjectName}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Flexible(
               fit: FlexFit.loose,
               child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Room No',
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
                              exam.roomNo == null ? 'N/A':exam.roomNo,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
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
                          exam.date == null ? 'N/A':exam.date,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Start',
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
                          exam.startTime == null ? 'N/A': AppFunction.getAmPm(exam.startTime),
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'End',
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
                          exam.endTime == null ? 'N/A': AppFunction.getAmPm(exam.endTime),
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
             ),
            // Container(
            //   height: 0.5,
            //   margin: EdgeInsets.only(top: 10.0),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         begin: Alignment.centerRight,
            //         end: Alignment.centerLeft,
            //         colors: [Colors.purple, Colors.deepPurple]),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
