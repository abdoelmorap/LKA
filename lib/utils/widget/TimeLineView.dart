// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Timeline.dart';
import 'package:infixedu/utils/permission_check.dart';

// ignore: must_be_immutable
class TimeLineView extends StatelessWidget {
  var progress = "";
  Timeline timeline;

  TimeLineView(this.timeline);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 14,
                height: 16,
                decoration: new BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 0.5,
                height: 150,
                decoration: new BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.rectangle,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                timeline.title,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                timeline.date,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                timeline.description,
                maxLines: 5,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 10,
              ),
              timeline.file != "" && timeline.file != null
                  ? ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        PermissionCheck().checkPermissions(context)
                          ..then((value) {
                            showDownloadAlertDialog(context);
                          });
                      },
                      // leading: Icon(Icons.file_present),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_present,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            "Download",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  showDownloadAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget yesButton = TextButton(
      child: Text("Download"),
      onPressed: () {
        timeline.file != null && timeline.file != ""
            ? downloadFile(timeline.file)
            : Utils.showToast('no file found');
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Download",
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Text("Would you like to download the file?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();

    String dirloc = "";
    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getApplicationSupportDirectory()).path;
    }
    Utils.showToast(dirloc);

    try {
      FileUtils.mkdir([dirloc]);
      Utils.showToast("Downloading...");
      await dio
          .download(InfixApi.root + url, dirloc + AppFunction.getExtention(url),
              onReceiveProgress: (receivedBytes, totalBytes) {
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
      });
    } catch (e) {
      print(e);
    }
    Utils.showToast(
        "Download Completed.Go to the download folder to find the file");
    progress = "Download Completed.Go to the download folder to find the file";
  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: const Text("Permission denied"),
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: const Text(
                  "You must grant all permission to use this application",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }
}
