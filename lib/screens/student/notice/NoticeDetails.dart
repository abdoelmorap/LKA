// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// Project imports:
import '../../../utils/CustomAppBarWidget.dart';
import '../../../utils/model/Notice.dart';

// ignore: must_be_immutable
class NoticDetailsLayout extends StatefulWidget {
  Notice notice;

  NoticDetailsLayout(this.notice);

  @override
  _NoticDetailsLayoutState createState() => _NoticDetailsLayoutState(notice);
}

class _NoticDetailsLayoutState extends State<NoticDetailsLayout> {
  Notice notice;

  _NoticDetailsLayoutState(this.notice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Notice Details'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                notice.title,
                maxLines: 1,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(20),
                    ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                notice.date,
                maxLines: 1,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: ScreenUtil().setSp(16.0),
                    ),
              ),
              SizedBox(
                height: 10.0,
              ),
              HtmlWidget(
                '''
              ${notice.destails ?? ""}
              ''',
                textStyle: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: ScreenUtil().setSp(14.0),
                    ),
                webView: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
