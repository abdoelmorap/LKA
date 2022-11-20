import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Student.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'package:infixedu/utils/widget/StudentSearchRow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/CustomAppBarWidget.dart';
import '../../utils/Utils.dart';
import '../../utils/model/GalleryModel.dart';
import 'package:http/http.dart' as http;

class StudentGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stateStudentGallery();
  }
}

class _stateStudentGallery extends State<StudentGallery> {
  String _token;
  Future<GalleryModel> stGallery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          title: "Gallery ",
        ),
        body: FutureBuilder<GalleryModel>(
          future: stGallery,
          builder: (context, data) {
            if (data.hasData) {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  var photo = "";
                  String image = photo.isEmpty || photo == ''
                      ? '${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg'
                      : InfixApi.root + photo;
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Column(children: [
                        Stack(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(image),
                                backgroundColor: Colors.grey,
                              ),
                              title: Text(
                                "",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ],
                        ),
                        data.data.data[index].image.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width,
                                    imageUrl:
                                        "${InfixApi.root}public/images/${data.data.data[index].image}",
                                    progressIndicatorBuilder: (BuildContext,
                                        String, DownloadProgress) {
                                      return Container(
                                        child: CircularProgressIndicator(),
                                        width: 100,
                                        height: 100,
                                      );
                                    }),
                              )
                            : SizedBox.shrink(),
                        Container(
                          child: Text(
                            data.data.data[index].content,
                            textAlign: TextAlign.justify,
                          ),
                          width: MediaQuery.of(context).size.width - 50,
                        ),
                        Row(children: [
                          SizedBox(
                            width: 10,
                            height: 50,
                          ),
                          // Container(
                          //   padding: const EdgeInsets.all(4.0),
                          //   decoration: BoxDecoration(
                          //     color: Colors.orange,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Icon(
                          //     Icons.thumb_up,
                          //     size: 25.0,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          const SizedBox(width: 4.0),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              child: Icon(
                                Icons.download,
                                size: 25.0,
                                color: Colors.white,
                              ),
                              onTap: () {
                                downloadFile(
                                    InfixApi.root +
                                        "public/images/" +
                                        data.data.data[index].image,
                                    context,
                                    data.data.data[index].image);
                              },
                            ),
                          ),
                          const SizedBox(width: 4.0),
                        ])
                      ]));
                },
                itemCount: data.data.data.length,
              );
            }
            return Container();
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
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
    })
      ..then((value) {
        stGallery = _StGallery();
      });
  }

  Future<void> downloadFile(
      String url, BuildContext context, String title) async {
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

      await dio.download(url, dirloc + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        var received = ((receivedBytes / totalBytes) * 100);
        var progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        if (received == 100.0) {
          if (url.contains('.pdf')) {
            Utils.showToast(
                "Download Completed. File is also available in your download folder."
                    .tr);
            Navigator.push(
                context,
                ScaleRoute(
                    page: DownloadViewer(
                        title: title, filePath: InfixApi.root + url)));
          } else {
            // ignore: deprecated_member_use
            await canLaunch(InfixApi.root + url)
                // ignore: deprecated_member_use
                ? await launch(InfixApi.root + url)
                : throw 'Could not launch ${InfixApi.root + url}';
          }
          Utils.showToast(
              "Download Completed. File is also available in your download folder."
                  .tr);
        }
      });
    } catch (e) {
      print(e);
    }
    var progress =
        "Download Completed.Go to the download folder to find the file".tr;
  }

  Future<GalleryModel> _StGallery() async {
    var id = await Utils.getIntValue("studentId") ??
        await Utils.getIntValue("myStudentId");
    final response = await http.get(Uri.parse(InfixApi.getPosts + "/$id"),
        headers: Utils.setHeader(_token.toString()));
    print(id);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      try {
        return GalleryModel.fromJson(jsonData);
      } catch (e) {
        print(e);

        throw ('Failed to load');
      }
    } else {
      throw ('Failed to load');
    }
  }
}
