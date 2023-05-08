import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:infixedu/utils/apis/Apis.dart';
import 'package:rxdart/rxdart.dart';
import '../../utils/CustomAppBarWidget.dart';

class ImagePst extends StatefulWidget {
  final String id;

  const ImagePst({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ImageStatePst();
  }
}

class ImageStatePst extends State<ImagePst> {
  TextEditingController postContent = TextEditingController();
  XFile photo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Send Post",
      ),
      body: ListView(children: [
        Center(
          child: photo == null
              ? Icon(Icons.import_contacts_sharp)
              : Image.file(
                  File(photo.path),
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
                BuildContext myCtxr;
                showDialog(
                    context: context,
                    builder: (ctxr) {
                      myCtxr = ctxr;
                      return AlertDialog(
                        content: CircularProgressIndicator(),
                      );
                    });
                String _token = "";
                _token = await (Utils.getStringValue('token'));

                print(widget.id);
                var request = http.MultipartRequest(
                    "POST", Uri.parse(InfixApi.postImage + "/${widget.id}"));
                request.fields['content'] = postContent.text;
                request.fields['student_id'] = widget.id.toString();
                request.headers.addAll({
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': _token,
                });
                image.Image resized_img = image.copyResize(
                    image.decodeImage((await photo.readAsBytes())),
                    width: 800,
                    height: 800);
                request.files.add(http.MultipartFile.fromBytes(
                    'image_file', image.encodeJpg(resized_img),
                    contentType: MediaType.parse('image/jpeg'),
                    filename: photo.path.split("/").last));
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
                  Navigator.of(myCtxr).pop();
                  print(response.reasonPhrase);
                  if (response.statusCode == 201) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Text("Posted Successfully"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Okay"))
                            ],
                          );
                        });
                    print("Uploaded!");
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content:
                                Text("Posted Failed Please Try Again later"),
                          );
                        });
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
    Future.delayed(Duration(seconds: 1), () {
      openCamera();
    });
  }

  openCamera() async {
    final ImagePicker _picker = ImagePicker();
    showDialog(
        context: context,
        builder: (ctxe) {
          return AlertDialog(
            content: Text("SelectImageSource"),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    photo =
                        (await _picker.pickImage(source: ImageSource.camera));
                    Navigator.of(ctxe).pop();

                    setState(() {});
                  },
                  child: Text("Camera")),
              ElevatedButton(
                  onPressed: () async {
                    photo =
                        (await _picker.pickImage(source: ImageSource.gallery));
                    Navigator.of(ctxe).pop();

                    setState(() {});
                  },
                  child: Text("Gallery"))
            ],
          );
        });
  }
}
