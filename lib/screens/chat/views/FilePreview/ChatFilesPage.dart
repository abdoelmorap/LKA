import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/chat/controller/chat_files_controller.dart';
import 'package:infixedu/screens/chat/views/FilePreview/ImagePreview.dart';
import 'package:infixedu/screens/chat/views/FilePreview/NetworkVideoPlayer.dart';
import 'package:infixedu/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/screens/chat/models/ChatFilesModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as time;

class ChatFilesPage extends StatefulWidget {
  final String chatId;
  final bool isGroup;
  ChatFilesPage({this.chatId, this.isGroup});
  @override
  _ChatFilesPageState createState() => _ChatFilesPageState();
}

class _ChatFilesPageState extends State<ChatFilesPage> {
  ChatFilesController _chatFilesController;

  @override
  void initState() {
    print(widget.chatId);
    if (widget.isGroup) {
      _chatFilesController =
          Get.put(ChatFilesController(widget.chatId, 'group'));
    } else {
      _chatFilesController =
          Get.put(ChatFilesController(widget.chatId, 'single'));
    }

    super.initState();
  }

  getLeadingIcon(MessageFile chatMessage) {
    if (chatMessage.messageType == 1) {
      //**png jpg jpeg
      return Icons.image;
    } else if (chatMessage.messageType == 2) {
      //**pdf
      return Icons.picture_as_pdf;
    } else if (chatMessage.messageType == 3) {
      //**doc docx
      return Icons.document_scanner;
    } else if (chatMessage.messageType == 4) {
      //**webm
      return Icons.video_call;
    } else if (chatMessage.messageType == 5) {
      //**mp4 3gp mkv
      return Icons.tv;
    } else {
      return Icons.nat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Files",
      ),
      body: Obx(() {
        if (_chatFilesController.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          if (_chatFilesController.chatFilesModel.value.messages.length == 0) {
            return Utils.noDataWidget();
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                _chatFilesController.chatFilesModel.value.messages.length,
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 10,
                ),
              );
            },
            itemBuilder: (context, index) {
              MessageFile chatMessage = widget.isGroup
                  ? _chatFilesController.chatFilesModel.value.messages[index]
                  : _chatFilesController.chatFilesModel.value.messages.entries
                      .elementAt(index)
                      .value;
              var timeago = time.format(chatMessage.createdAt);
              if (chatMessage.messageType == 1) {
                //** png jpg jpeg
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ImagePreviewPage(
                                title: chatMessage.originalFileName,
                                imageUrl:
                                    "${AppConfig.domainName}/${chatMessage.fileName}",
                              ));
                        },
                        child: FancyShimmerImage(
                          imageUrl:
                              "${AppConfig.domainName}/${chatMessage.fileName}",
                          boxFit: BoxFit.contain,
                          width: 100,
                          height: 100,
                          errorWidget: FancyShimmerImage(
                            imageUrl:
                                "${AppConfig.domainName}/public/chat/images/bw-spondon-icon.png",
                            boxFit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "$timeago",
                        style: Get.textTheme.subtitle1.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                );
              } else if (chatMessage.messageType == 2) {
                //**pdf
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DownloadViewer(
                              title: "${chatMessage.originalFileName}",
                              filePath:
                                  "${AppConfig.domainName}/${chatMessage.fileName}",
                            )));
                  },
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  dense: true,
                  title: Text(
                    "${chatMessage.originalFileName}",
                    style: Get.textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    "$timeago",
                    style: Get.textTheme.subtitle1.copyWith(fontSize: 12),
                  ),
                  leading: Icon(getLeadingIcon(chatMessage),
                      color: Get.theme.primaryColor),
                );
              } else if (chatMessage.messageType == 3) {
                //** DOC/DOCX */
                return ListTile(
                  onTap: () async {
                    final url =
                        "${AppConfig.domainName}/${chatMessage.fileName}";
                    // ignore: deprecated_member_use
                    if (await canLaunch(url)) {
                      // ignore: deprecated_member_use
                      await launch(url);
                    } else {
                      throw 'Unable to open url : $url';
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  dense: true,
                  title: Text(
                    "${chatMessage.originalFileName}",
                    style: Get.textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    "$timeago",
                    style: Get.textTheme.subtitle1.copyWith(fontSize: 12),
                  ),
                  leading: Icon(getLeadingIcon(chatMessage),
                      color: Get.theme.primaryColor),
                );
              } else if (chatMessage.messageType == 3) {
                //** DOC/DOCX */
                return ListTile(
                  onTap: () async {
                    final url =
                        "${AppConfig.domainName}/${chatMessage.fileName}";
                    // ignore: deprecated_member_use
                    if (await canLaunch(url)) {
                      // ignore: deprecated_member_use
                      await launch(url);
                    } else {
                      throw 'Unable to open url : $url';
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  dense: true,
                  title: Text(
                    "${chatMessage.originalFileName}",
                    style: Get.textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    "$timeago",
                    style: Get.textTheme.subtitle1.copyWith(fontSize: 12),
                  ),
                  leading: Icon(getLeadingIcon(chatMessage),
                      color: Get.theme.primaryColor),
                );
              } else if (chatMessage.messageType == 4 ||
                  chatMessage.messageType == 5) {
                //** DOC/DOCX */
                return ListTile(
                  onTap: () async {
                    Get.to(() => NetworkVideoPlayerView(
                        videoUrl:
                            "${AppConfig.domainName}/${chatMessage.fileName}"));
                  },
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  dense: true,
                  title: Text(
                    "${chatMessage.originalFileName}",
                    style: Get.textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    "$timeago",
                    style: Get.textTheme.subtitle1.copyWith(fontSize: 12),
                  ),
                  leading: Icon(getLeadingIcon(chatMessage),
                      color: Get.theme.primaryColor),
                );
              }
              return SizedBox.shrink();
            },
          );
        }
      }),
    );
  }
}
