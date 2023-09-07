import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
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

import '../../utils/model/StudentDetailsModel.dart';

class StudentGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stateStudentGallery();
  }
}

class _stateStudentGallery extends State<StudentGallery> {
  String? _token;
  Future<GalleryModel>? stGallery;

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
                  int currentIndexPage =1;

                  var photo = "";
                  String image = photo.isEmpty || photo == ''
                      ? '${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg'
                      : InfixApi.root + photo;

                  return PostContainer(data,index,image);
                },
                itemCount: data.data!.dATA!.length,
              );
            }
            return Container();
          },
        ));
  }
Widget PostContainer(data,index,image){
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
              title: Column(children: [SizedBox(height: 5,),
                Text(
                  data.data!.dATA![index].TeacherName??'',
                  style: GoogleFonts.bubblegumSans(fontSize: 21,color: Colors.pink,fontWeight: FontWeight.bold),
                ),SizedBox(height: 0 ,),Text(
                  "${ DateTime.parse(data.data!.dATA![index].images[0]!.createdAt).day.toString()}/${
                      DateTime.parse(data.data!.dATA![index].images[0]!.createdAt).month.toString()}/${ DateTime.parse(data.data!.dATA![index].images[0]!.createdAt).year.toString()}",
                  textAlign: TextAlign.justify,style:  Theme.of(context).textTheme.headline6?.copyWith(fontSize: 12),
                ),
              ],crossAxisAlignment: CrossAxisAlignment.start,)
            ),
          ],
        ),
        data.data!.dATA![index].images!.length!=0
            ? Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 8.0),
          child:


          CarouselSlider.builder(
            itemCount: data.data!.dATA![index].images!.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                Container(
                  child:
                    CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        height: double.infinity,
                        imageUrl:
                        "${InfixApi.root}public/images/${data.data!.dATA![index].images![itemIndex].url}",
                        progressIndicatorBuilder: (BuildContext,
                            String, DownloadProgress) {
                          return Center(
                            child: CircularProgressIndicator(),

                          );
                        }),

                ), options:  CarouselOptions(
              height: 400,
              aspectRatio: 16/9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
              onPageChanged: (myIndex, reason) {

                setState(() {
                  data.data!.dATA![index].CurrentIndex=myIndex;
                });
              }
          ),
          ),

        )
            : SizedBox.shrink(),
        data.data!.dATA![index].images!.length!=0?  DotsIndicator(
          dotsCount: data.data!.dATA![index].images!.length==0?1:data.data!.dATA![index].images!.length,
          position: data.data!.dATA![index].images!.length==0?0:  data.data!.dATA![index].CurrentIndex,
        ) : SizedBox.shrink(),
        Container(
          child: Text(
            data.data!.dATA![index].content!,
            textAlign: TextAlign.justify,style: GoogleFonts.butterflyKids(fontSize: 29,color: Colors.pink,fontWeight: FontWeight.w900),
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
                      data.data!.dATA![index].images![ data.data!.dATA![index].CurrentIndex??0].url.toString(),
                  context,

                  data.data!.dATA![index].images![ data.data!.dATA![index].CurrentIndex??0].url.toString(),);
              },
            ),
          ),
          const SizedBox(width: 4.0),
        ])
      ]));
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
      String url, BuildContext context, String? title) async {
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
        if (received == 35.0) {
          Utils.showToast(
              "Download Is 35%."
                  .tr);


        }
        if (received == 75.0) {
          Utils.showToast(
              "Download Is 75%."
                  .tr);


        }
        if (received == 100.0) {
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
        await Utils.getIntValue("myStudentId")??  await Utils.getIntValue("childID");



    final response = await http.get(Uri.parse(InfixApi.getPosts + "/${id!}"),
        headers: Utils.setHeader(_token.toString()));
    print(response.body);
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
