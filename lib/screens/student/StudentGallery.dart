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
          title: "Gallery ",
        ),
        body: ListView(children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Column(children: [
              Text("كانت لكمات قوية حقا من هذا الشب  الوسيم والقوي "),
              Image.network(
                  "https://lka-eg.com/wp-content/uploads/2022/10/IMG-197.jpg"),
            ]),
          )
        ]));
  }
}
