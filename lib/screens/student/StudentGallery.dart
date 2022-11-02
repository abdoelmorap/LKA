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
        body: FutureBuilder(
          future: () {} as Future,
          builder: (context, data) {
            return ListView(children: [
              Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  Text("كانت لكمات قوية حقا من هذا الشب  الوسيم والقوي "),
                  Image.network(
                      "https://lka-eg.com/wp-content/uploads/2022/10/IMG-197.jpg"),
                ]),
              )
            ]);
          },
        ));
  }

  Future fetchContent() async {
    // final response = await http.get(Uri.parse(InfixApi.getAllContent()),
    //     headers: Utils.setHeader(_token));
    //
    // if (response.statusCode == 200) {
    //   var jsonData = jsonDecode(response.body);
    //   return ContentList.fromJson(jsonData['data']['uploadContents']);
    // } else {
    //   throw Exception('failed to load');
    // }
  }

  @override
  void initState() {
    super.initState();
  }
}
