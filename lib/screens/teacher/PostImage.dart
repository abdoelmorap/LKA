import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:infixedu/utils/apis/Apis.dart';
import 'package:rxdart/rxdart.dart';
import '../../utils/CustomAppBarWidget.dart';

class ImagePst extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageStatePst();
  }
}

class ImageStatePst extends State<ImagePst> {
  TextEditingController postContent = TextEditingController();
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
              controller: postContent,
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
          child: ElevatedButton(
              onPressed: () async {
                String? _token = "";
                _token = await (Utils.getStringValue('token'));

                List<int> imageBytes = await photo!.readAsBytes();
                var request = http.MultipartRequest(
                    "POST", Uri.parse(InfixApi.postImage + "/1"));
                request.fields['content'] = postContent.text;

                request.headers.addAll({
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': _token!,
                });

                request.files.add(http.MultipartFile(
                    'image_file',
                    photo!.readAsBytes().asStream(),
                    (File(photo!.path)).lengthSync(),
                    filename: photo!.path.split("/").last));
                // request.files.add(http.MultipartFile(
                //     'image_file',
                //     (await FlutterImageCompress.compressWithFile(
                //       photo!.path,
                //       minWidth: 800,
                //       minHeight: 600,
                //       quality: 94,
                //       rotate: 90,
                //     )).,
                //     (File(photo!.path)).lengthSync(),
                //     filename: photo!.path.split("/").last));

                request.send().then((response) {
                  print(response.reasonPhrase);
                  if (response.statusCode == 201) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Text("Posted Successfully"),
                          );
                        });
                    print("Uploaded!");
                  }
                });
              },
              child: Text("Send")),
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

    photo = (await _picker.pickImage(source: ImageSource.camera));
    setState(() {});
  }
}
