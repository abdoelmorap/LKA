// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/zoom_meeting.dart';
import 'package:infixedu/utils/permission_check.dart';
import 'package:infixedu/webview/launch_webview.dart';
import 'ScaleRoute.dart';

// ignore: must_be_immutable
class ZoomMeetingRow extends StatefulWidget {
  ZoomMeeting zoomMeeting;

  ZoomMeetingRow(this.zoomMeeting);

  @override
  _DormitoryScreenState createState() => _DormitoryScreenState(zoomMeeting);
}

class _DormitoryScreenState extends State<ZoomMeetingRow> {
  ZoomMeeting zoomMeeting;

  _DormitoryScreenState(this.zoomMeeting);

  @override
  void initState() {
    PermissionCheck().checkPermissions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              zoomMeeting.topic,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: ScreenUtil().setSp(15)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Start Date',
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
                          '${zoomMeeting.startDate}',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Time',
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
                          '${zoomMeeting.startTime} - ${DateFormat('hh:mm a').format(zoomMeeting.endTime)}',
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
                          'Password',
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
                          '${zoomMeeting.password}',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                        child: Text(
                          'Join',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        // borderSide:
                        //     BorderSide(width: 1, color: Colors.deepPurple),
                        onPressed: () async {
                          final _url = InfixApi.getJoinMeetingUrlApp(
                              mid: zoomMeeting.meetingId);

                          print('App URL: ${InfixApi.getJoinMeetingUrlApp(mid: zoomMeeting.meetingId)}');
                          print('Web URL: ${InfixApi.getJoinMeetingUrlWeb(mid: zoomMeeting.meetingId)}');
                          // ignore: deprecated_member_use
                          if (await canLaunch(_url)) {
                            // ignore: deprecated_member_use
                            await launch(_url);
                          } else {
                            Navigator.push(
                                context,
                                ScaleRoute(
                                    page: LaunchWebView(
                                        launchUrl: InfixApi.getJoinMeetingUrlWeb(
                                            mid: zoomMeeting.meetingId),title: zoomMeeting.topic,)));
                          }
                        }),
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
      ),
    );
  }
}
