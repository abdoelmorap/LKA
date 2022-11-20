// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:pdf_flutter/pdf_flutter.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';

// import 'package:infixedu/utils/pdf_flutter.dart';

class DownloadViewer extends StatefulWidget {
  final String title;
  final String filePath;
  DownloadViewer({this.title, this.filePath});
  @override
  _DownloadViewerState createState() => _DownloadViewerState();
}

class _DownloadViewerState extends State<DownloadViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: PDF.network(
        widget.filePath,
      ),
    );
  }
}
