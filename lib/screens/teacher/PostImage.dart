import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/CustomAppBarWidget.dart';

class ImagePst extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageStatePst();
  }
}

class ImageStatePst extends State<ImagePst> {
  XFile? photo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: "Send Post",
      ),
      body: ListView(children: [
        Center(
          child: photo == null
              ? Icon(Icons.import_contacts_sharp)
              : Image.file(
                  File(photo!.path),
                  width: MediaQuery.of(context).size.width,
                ),
        ),
        Column(children: [
          SizedBox(
            height: 5,
          ),
          Text(
            "Post",
            style: TextStyle(
                color: Color(0xff93cfc4),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: TextField(
              // controller: Comment,
              decoration: new InputDecoration(
                fillColor: Color(0xFFFFFFFF),
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              maxLines: 4,
            ),
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 90 / 100,
          )
        ]),
        Container(
          child: ElevatedButton(onPressed: () async {}, child: Text("Send")),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
        ),
        SizedBox(
          height: 100,
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    openCamera();
  }

  openCamera() async {
    final ImagePicker _picker = ImagePicker();

    photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }
}
