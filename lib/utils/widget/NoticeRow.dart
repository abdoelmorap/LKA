// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:infixedu/screens/student/notice/NoticeDetails.dart';
import 'package:infixedu/utils/model/Notice.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';

// ignore: must_be_immutable
class NoticRowLayout extends StatefulWidget {
  Notice notice;

  NoticRowLayout(this.notice);

  @override
  _NoticRowLayoutState createState() => _NoticRowLayoutState(notice);
}

class _NoticRowLayoutState extends State<NoticRowLayout> {
  Notice notice;

  _NoticRowLayoutState(this.notice);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
          Radius.circular(10)
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(context, ScaleRoute(page: NoticDetailsLayout(notice)));
        },
        title: Text(
          notice.title,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(15.0)),
        ),
        subtitle: Text(
          notice.date,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.w300, fontSize: ScreenUtil().setSp(13.0)),
        ),
      ),
    );
  }
}
