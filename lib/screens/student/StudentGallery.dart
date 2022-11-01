import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/CustomAppBarWidget.dart';

class StudentGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stateStudentGallery();
  }
}

class _stateStudentGallery extends State<StudentGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          title: "Send Post",
        ),
        body: ListView(children: [
          Card(
            child: Column(children: []),
          )
        ]));
  }
}
