// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:infixedu/utils/model/Teacher.dart';

// ignore: must_be_immutable
class StudentTeacherRowLayout extends StatefulWidget {
  Teacher teacher;
  dynamic per;

  StudentTeacherRowLayout(this.teacher, this.per);

  @override
  _StudentTeacherRowLayoutState createState() =>
      _StudentTeacherRowLayoutState();
}

class _StudentTeacherRowLayoutState extends State<StudentTeacherRowLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: 18,
                child: Image.asset(
                  'assets/images/teacher.png',
                  scale: 2.0,
                  color: Color(0xffcf939e),
                )),
            SizedBox(
              width: 5,
            ),
            Text(widget.teacher.teacherName,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                // ignore: deprecated_member_use
                await canLaunch('mailto:${widget.teacher.teacherEmail}')
                    // ignore: deprecated_member_use
                    ? await launch('mailto:${widget.teacher.teacherEmail}')
                    : throw 'Could not launch ${widget.teacher.teacherEmail}';
              },
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Icon(
                      Icons.mail_outline,
                      color: Color(0xffcf939e),
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.teacher.teacherEmail,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            widget.teacher.teacherPhone == null ||
                    widget.teacher.teacherPhone == ''
                ? Container()
                : InkWell(
                    onTap: () async {
                      // ignore: deprecated_member_use
                      await canLaunch('tel:${widget.teacher.teacherPhone}')
                          // ignore: deprecated_member_use
                          ? await launch('tel:${widget.teacher.teacherPhone}')
                          : throw 'Could not launch ${widget.teacher.teacherPhone}';
                    },
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color(0xffcf939e),
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.teacher.teacherPhone}',
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
