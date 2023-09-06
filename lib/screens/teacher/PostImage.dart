import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  final String? id;

  const ImagePst({Key? key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ImageStatePst();
  }
}

class ImageStatePst extends State<ImagePst> {
  TextEditingController postContent = TextEditingController();
  List<XFile>? photo;
  String GroupId="";
  double loading = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBarWidget(
        title: "Send Post",
      ),
      body: ListView(children: [
        SizedBox(height: 25,),
      photo == null
              ? Icon(Icons.import_contacts_sharp)
              :Container(child:  GridView.builder(itemBuilder: (context,indx){
      if (indx==photo!.length!-1) {
        return  Container(child: Stack(children: [SizedBox(width: 10000,height: 1000000000,)
          ,SizedBox(child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Image border
            child: SizedBox.fromSize(
              size: Size.fromRadius(48), // Image radius
              child:Image.file(
                File(photo![indx].path),
                fit: BoxFit.cover,
              ),
            ),
          ),height: 1555,width: 1555,),


         Align(child: GestureDetector(onTap: ()=>openCamera(),
            child: Icon(Icons.add,size: 60,),
          ),alignment: Alignment.center,),GestureDetector(child: Icon(Icons.close_rounded,color: Colors.red,),onTap: (){
            photo!.removeAt(indx);
            setState(() {

            });
          },)
        ]
        ),width: 10000,height: 1000000000,);
      } else
        return  SizedBox(child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Image border
          child: SizedBox.fromSize(
            size: Size.fromRadius(48), // Image radius
            child:Image.file(
              File(photo![indx].path),
              fit: BoxFit.cover,
            ),
          ),
        ),height: 1555,width: 1555,);
        //   Image.file(
        //   File(photo![indx].path),
        // );


      },itemCount: photo!.length,    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 2.0,
      ),),height: MediaQuery.of(context).size.height/3,)
,
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
String? _fullName='';
                print(widget.id);
                _fullName=await  Utils.getStringValue('full_name');
                var request = MultipartRequest(
                    "POST", Uri.parse(InfixApi.postImage + "/${widget.id}"), onProgress: (int bytes, int totalBytes) {

                  loading=(bytes/totalBytes);
             // if(loading==.25
             // ||loading==.35||loading==.50||loading==.65||loading==.75||loading==.90||loading==.100){
               EasyLoading.showProgress(loading, status: 'Uploading...\n${(loading * 100).toStringAsFixed(0)}%');

             // }

                },);
                request.fields['content'] = postContent.text;
                request.fields['student_id'] = widget.id.toString();
                request.fields['ISGroup'] = GroupId;
                request.fields['TeacherName'] = _fullName??'';
                request.fields['count'] = photo!.length.toString();
                request.headers.addAll({
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': _token!,
                });

                //used Code
                for(var p in photo!){
                  image.Image resized_img = image.copyResize(
                      image.decodeImage((await p!.readAsBytes()))!,
                      width: 800,
                      height: 800);
                  request.files.add(http.MultipartFile.fromBytes(
                      'image_file'+photo!.indexOf(p)!.toString(), image.encodeJpg(resized_img),
                      contentType: MediaType.parse('image/jpeg'),
                      filename: p!.path.split("/").last));
                }





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
                  EasyLoading.dismiss();

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
                                Text("Posted Failed Please Try Again later "+response.reasonPhrase.toString()),
                          );
                        });
                  }
                });
              },
              child: Text("Send")),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
        ),

      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      GroupId =widget.id.toString()+Random().nextInt(54844).toString()+DateTime.now().millisecondsSinceEpoch.toString();

      openCamera();
    });
  }

  openCamera() async {
    final ImagePicker _picker = ImagePicker();
    if(photo==null){
      photo =    await _picker.pickMultiImage(
          imageQuality: 40, maxHeight: 800, maxWidth: 800);}else{
      photo!.addAll((
          await _picker.pickMultiImage(
              imageQuality: 40, maxHeight: 800, maxWidth: 800)));
    }
    setState(() {});
    // showDialog(
    //     context: context,
    //     builder: (ctxe) {
    //       return AlertDialog(
    //         content: Text("SelectImageSource"),
    //         actions: [
    //           ElevatedButton(
    //               onPressed: () async {
    //                 // photo =
    //                 //     (await _picker.pickMultiImage(source: ImageSource.camera));
    //                 // Navigator.of(ctxe).pop();
    //                 //
    //                 // setState(() {});
    //               },
    //               child: Text("Camera")),
    //           ElevatedButton(
    //               onPressed: () async {
    //                 // photo =
    //                 //     (await _picker.pickMultiImage(source: ImageSource.gallery));
    //                 // Navigator.of(ctxe).pop();
    //                 photo =    await _picker.pickMultiImage(
    //                     imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    //                 setState(() {});
    //               },
    //               child: Text("Gallery"))
    //         ],
    //       );
    //     });
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
      String method,
      Uri url, {
        required this.onProgress,
      }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        if(total >= bytes) {
          sink.add(data);
        }
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}