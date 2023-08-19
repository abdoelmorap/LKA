// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

// Package imports:

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';

// import 'package:infixedu/utils/pdf_flutter.dart';

class DownloadViewer extends StatefulWidget {
  final String? title;
  final String? filePath;
  DownloadViewer({this.title, this.filePath});
  @override
  _DownloadViewerState createState() => _DownloadViewerState();
}

class _DownloadViewerState extends State<DownloadViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: PDF().cachedFromUrl(
        widget.filePath!,
      ),
    );
  }
}
