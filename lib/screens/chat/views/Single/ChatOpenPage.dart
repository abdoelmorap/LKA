import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/chat/controller/pusher_controller.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/LoadMoreIndicator.dart';
import 'package:infixedu/utils/MediaUtils.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controller/chat_controller.dart';
import '../../controller/chat_open_controller.dart';
import '../../models/ChatGroup.dart';
import '../../models/ChatMessage.dart';
import '../../models/ChatUser.dart';
import '../FilePreview/ChatFilesPage.dart';
import 'ChatLoadMore.dart';
import 'ChatMessageWidget.dart';

class ChatOpenPage extends StatefulWidget {
  final String? avatarUrl;
  final String? chatTitle;
  final int? userId;
  final int? onlineStatus;
  ChatOpenPage(
      {this.avatarUrl, this.chatTitle, this.userId, this.onlineStatus});

  @override
  _ChatOpenPageState createState() => _ChatOpenPageState();
}

class _ChatOpenPageState extends State<ChatOpenPage> {
  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final _focusNode = FocusNode();
  ChatOpenController? _chatOpenController;

  ChatController _chatController = Get.put(ChatController());

  final TextEditingController _chatMessageCtrl = TextEditingController();

  final ScrollController scrollController = ScrollController();
  final PusherController _pusherController = Get.put(PusherController());
  Future? chatOpen;

  bool scrolling = false;
  bool showSend = false;
  bool replyClick = false;
  bool searchClicked = false;

  ChatLoadMore? source;

  bool showMenu = false;
  bool showPortal = false;

  final _eventName = 'client-single-typing';

  @override
  void initState() {
    _chatOpenController = Get.put(ChatOpenController(widget.userId));
    source = ChatLoadMore(widget.userId, _chatOpenController);
    _focusNode.addListener(_focusNodeListener);

    if (_chatController.chatSettings.value.chatSettings!.chatMethod ==
        "pusher") {
      // _pusherController.chatOpenId = widget.userId;
      Future.delayed(Duration(seconds: 3), () {
        _pusherController.chatOpenSingle(widget.userId, source);
      });
    }

    scrollController.addListener(() {
      // print(scrollController.offset);
      if (scrollController.offset > 0.0) {
        setState(() {
          scrolling = true;
        });
      } else if (scrollController.offset <= 0.0) {
        setState(() {
          scrolling = false;
        });
      }
    });

    super.initState();
  }

  void onTriggerEventPressed() async {
    try {
      _pusherController.pusher.trigger(PusherEvent(
          channelName: 'private-single-chat' + '.${widget.userId}',
          eventName: _eventName,
          data: "kjk"));
      print('typing');
    } catch (e) {
      log(e.toString());
    }
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      setState(() {
        showSend = true;
      });
      // _openFilePickerSection = false;
    } else {
      setState(() {
        showSend = false;
      });
    }
  }

  getOnlineColor(status) {
    if (status == 0) {
      return Colors.transparent;
    } else if (status == 1) {
      return Colors.green;
    } else if (status == 2) {
      return Colors.amber;
    } else if (status == 3) {
      return Colors.red;
    }
  }

  String getStatusTitle(status) {
    if (status == 0) {
      return "";
    } else if (status == 1) {
      return "Online";
    } else if (status == 2) {
      return "Away";
    } else if (status == 3) {
      return "Busy";
    }
    return "";
  }

  File? file;

  Future openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'doc',
        'docx',
        'pdf',
        'mp4',
        '3gp',
        'webm'
      ],
      type: FileType.custom,
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    } else {
      Utils.showToast("Cancelled");
    }
  }

  Widget fileShowWidget() {
    if (MediaUtils.isImage(file!.path)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.file(
              file!,
              width: 100,
              height: 100,
              alignment: Alignment.centerLeft,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  file = null;
                });
              },
              child: Icon(
                FontAwesomeIcons.times,
                color: Get.theme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      );
    } else if (MediaUtils.isPdf(file!.path)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.solidFilePdf,
                color: Get.theme.primaryColor, size: 20.sp),
            SizedBox(
              width: 5,
            ),
            Text(
              "${file!.path.split('/').last}",
              maxLines: 1,
              style: Get.textTheme.subtitle1!.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  file = null;
                });
              },
              child: Icon(
                FontAwesomeIcons.times,
                color: Get.theme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      );
    } else if (MediaUtils.isWord(file!.path)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.solidFileWord,
                color: Get.theme.primaryColor, size: 20.sp),
            SizedBox(
              width: 5,
            ),
            Text(
              "${file!.path.split('/').last}",
              maxLines: 1,
              style: Get.textTheme.subtitle1!.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  file = null;
                });
              },
              child: Icon(
                FontAwesomeIcons.times,
                color: Get.theme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      );
    } else if (MediaUtils.isVideo(file!.path)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.tv,
                color: Get.theme.primaryColor, size: 15.sp),
            SizedBox(
              width: 10,
            ),
            Text(
              "${file!.path.split('/').last}",
              maxLines: 1,
              style: Get.textTheme.subtitle1!.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  file = null;
                });
              },
              child: Icon(
                FontAwesomeIcons.times,
                color: Get.theme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    source!.dispose();
    _chatOpenController!.onClose();
    // _pusherController.pusher.disconnect();

    _pusherController.pusher
        .unsubscribe(channelName: 'private-single-chat' + '.${widget.userId}');

    _pusherController.pusher.unsubscribe(
        channelName:
            'private-single-chat' + '.${int.parse(_chatController.id.value!)}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: chatAppBarWidget(),
        body: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Stack(
            children: [
              Obx(() {
                if (_chatController
                        .chatSettings.value.chatSettings!.chatMethod !=
                    "pusher") {
                  return StreamBuilder<Object>(
                      stream: Stream.periodic(
                          Duration(seconds: 5), (_) => source!.checkNewMsg()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox.shrink();
                        } else {
                          return SizedBox.shrink();
                        }
                      });
                } else {
                  return SizedBox.shrink();
                }
              }),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        LoadingMoreList<ChatMessage?>(
                          ListConfig<ChatMessage?>(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            reverse: true,
                            indicatorBuilder: BuildIndicatorBuilder(
                              source: source,
                              isSliver: false,
                              name: 'Start New Conversation'.tr,
                            ).buildIndicator,
                            addAutomaticKeepAlives: true,
                            itemBuilder: (BuildContext c,
                                ChatMessage? chatMessage, int index) {
                              return MessageItemWidget(
                                  chatMessage: chatMessage,
                                  name: widget.chatTitle,
                                  avatarUrl: widget.avatarUrl,
                                  currentUserId: _chatOpenController!.id.value,
                                  menuVisible: false,
                                  showActions: true,
                                  activeStatus: _chatOpenController!
                                      .activeUser.value!.activeStatus,
                                  onTapMenu: () {
                                    onMenuPress(
                                      context: context,
                                      showActions: false,
                                      chatMessage: chatMessage!,
                                    );
                                  });
                            },
                            sourceList: source!,
                          ),
                          key: const Key('homePageLoadMoreKey'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: scrolling
                                ? IconButton(
                                    key: ValueKey<int>(0),
                                    onPressed: () {
                                      scrollController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    icon: Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Get.theme.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(
                                    key: ValueKey<int>(1),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    color: Colors.white,
                    child: Obx(() {
                      if (_chatOpenController!.isLoading.value) {
                        return Container();
                      } else {
                        if (_chatOpenController!.activeUser.value!.block!) {
                          return SizedBox.shrink();
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                key: ValueKey<int>(10),
                                child: replyClick
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Replying to ${_chatOpenController!.selectedChatMsg.value.fromId.toString() == _chatOpenController!.id.value ? "yourself" : _chatOpenController!.selectedChatMsg.value.fromUser!.fullName} ",
                                                    style: Get
                                                        .textTheme.subtitle1!
                                                        .copyWith(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_chatOpenController!.selectedChatMsg.value.message}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Get
                                                        .textTheme.subtitle1!
                                                        .copyWith(
                                                      overflow:
                                                          TextOverflow.clip,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  replyClick = false;
                                                });
                                                _chatOpenController!
                                                    .selectedChatMsg
                                                    .value = ChatMessage();
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.times,
                                                color: Get.theme.primaryColor,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                key: ValueKey<int>(12),
                                child: file != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(child: fileShowWidget()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var formData =
                                                  DIO.FormData.fromMap({
                                                'from_id': int.parse(
                                                    _chatOpenController!
                                                        .id.value!),
                                                'to_id': widget.userId,
                                                'message':
                                                    _chatMessageCtrl.text,
                                                'file_attach': await DIO
                                                    .MultipartFile.fromFile(
                                                  file!.path,
                                                  filename:
                                                      file!.path.split('/').last,
                                                )
                                              });

                                              await source!
                                                  .submitText(
                                                      hasFile: true,
                                                      formData: formData)
                                                  .then((value) {
                                                _chatMessageCtrl.clear();
                                              });
                                            },
                                            child: Icon(
                                              Icons.send,
                                              color: Get.theme.primaryColor,
                                              size: 20.sp,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Obx(() {
                                      return CachedNetworkImage(
                                        imageUrl:
                                            "${AppConfig.domainName}/${_chatOpenController!.imageUrl.value}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 25.w,
                                          height: 25.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.network(
                                          "${AppConfig.domainName}/public/chat/images/bw-spondon-icon.png",
                                          width: 20.w,
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: TextField(
                                        controller: _chatMessageCtrl,
                                        focusNode: _focusNode,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 6,
                                        minLines: 1,
                                        onChanged: (_) {
                                          onTriggerEventPressed();
                                        },
                                        textInputAction:
                                            TextInputAction.newline,
                                        scrollPhysics: BouncingScrollPhysics(),
                                        style: Get.textTheme.subtitle1!.copyWith(
                                          fontSize: 13,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          hintText: "Type message...",
                                          hintStyle: TextStyle(
                                            color: Colors.black54,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: showSend
                                        ? file != null
                                            ? SizedBox.shrink()
                                            : InkWell(
                                                onTap: () async {
                                                  if (_chatMessageCtrl
                                                          .text.length >
                                                      0) {
                                                    if (replyClick) {
                                                      Map data = {
                                                        'reply':
                                                            _chatOpenController!
                                                                .selectedChatMsg
                                                                .value
                                                                .id,
                                                        'from_id': int.parse(
                                                            _chatOpenController!
                                                                .id.value!),
                                                        'to_id': widget.userId,
                                                        'message':
                                                            _chatMessageCtrl
                                                                .text,
                                                      };
                                                      await source!
                                                          .submitText(
                                                              data: data,
                                                              hasFile: false)
                                                          .then((value) {
                                                        _chatMessageCtrl
                                                            .clear();
                                                      });
                                                      setState(() {
                                                        replyClick = false;
                                                      });
                                                    } else {
                                                      Map data = {
                                                        'from_id': int.parse(
                                                            _chatOpenController!
                                                                .id.value!),
                                                        'to_id': widget.userId,
                                                        'message':
                                                            _chatMessageCtrl
                                                                .text,
                                                      };
                                                      await source!
                                                          .submitText(
                                                              data: data,
                                                              hasFile: false)
                                                          .then((value) {
                                                        _chatMessageCtrl
                                                            .clear();
                                                      });
                                                    }
                                                  } else {
                                                    CustomSnackBar()
                                                        .snackBarWarning(
                                                            "Please type something");
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.send,
                                                  color: Get.theme.primaryColor,
                                                  size: 20.sp,
                                                ),
                                              )
                                        : InkWell(
                                            onTap: openFilePicker,
                                            child: Icon(
                                              Icons.attach_file,
                                              color: Get.theme.primaryColor,
                                              size: 20.sp,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToSelectedContent(GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  final GlobalKey textFieldKey = GlobalKey();

  final TextEditingController forwardMessageCtrl = TextEditingController();

  onForwardClick(
      {BuildContext? context,
      bool? showActions,
      ChatMessage? chatMessage,
      bool menuVisible = true}) {
    final ChatController chatController = Get.put(ChatController());

    final child = Center(
      child: SafeArea(
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Forward Message",
                        style: Get.textTheme.subtitle1!.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      MessageItemWidget(
                        chatMessage: chatMessage,
                        currentUserId: _chatOpenController!.id.value,
                        menuVisible: menuVisible,
                        showActions: showActions,
                        activeStatus:
                            _chatOpenController!.activeUser.value!.activeStatus,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                        child: TextFormField(
                          key: textFieldKey,
                          controller: forwardMessageCtrl,
                          maxLines: 2,
                          onTap: () {
                            _scrollToSelectedContent(textFieldKey);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Type a message here (optional)",
                            hintStyle: Get.textTheme.subtitle1!.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      ListView.separated(
                          itemCount:
                              chatController.chatModel.value.users!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          padding:
                              EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          itemBuilder: (context, index) {
                            ChatUser chatUser =
                                chatController.chatModel.value.users![index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${chatUser.fullName ?? ""}",
                                  style: Get.textTheme.subtitle1!
                                      .copyWith(fontSize: 14),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      '${AppConfig.domainName}/${chatUser.avatarUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 25.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.account_circle_rounded),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    Map data = {
                                      'from_id': _chatOpenController!.id.value,
                                      'to_id': chatUser.id,
                                      'message': forwardMessageCtrl.text,
                                      'forward': chatMessage!.id,
                                    };

                                    await _chatOpenController!
                                        .forwardMessage(data, false)
                                        .then((value) {
                                      forwardMessageCtrl.clear();
                                      Get.back();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                      ListView.separated(
                          itemCount:
                              chatController.chatModel.value.groups!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          padding:
                              EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          itemBuilder: (context, groupIndex) {
                            ChatGroup chatGroup = chatController
                                .chatModel.value.groups![groupIndex];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${chatGroup.name ?? ""}",
                                  style: Get.textTheme.subtitle1!
                                      .copyWith(fontSize: 14),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      '${AppConfig.domainName}/${chatGroup.photoUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 25.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.account_circle_rounded),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    Map data = {
                                      'user_id': _chatOpenController!.id.value,
                                      'group_id': chatGroup.id,
                                      'message': forwardMessageCtrl.text,
                                      'forward': chatMessage!.id,
                                    };

                                    await _chatOpenController!
                                        .forwardMessage(data, true)
                                        .then((value) {
                                      forwardMessageCtrl.clear();
                                      Get.back();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Get.back(),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Container(
                    color: Colors.black12,
                  ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutBack,
                builder: (context, val, child) => Transform.scale(
                  scale: val,
                  child: child,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onMenuPress(
      {BuildContext? context,
      bool? showActions,
      required ChatMessage chatMessage,
      bool menuVisible = true}) {
    final child = Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              chatMessage.fromId.toString() == _chatOpenController!.id.value
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: <Widget>[
            MessageItemWidget(
              name: widget.chatTitle,
              chatMessage: chatMessage,
              currentUserId: _chatOpenController!.id.value,
              menuVisible: menuVisible,
              showActions: showActions,
              activeStatus: _chatOpenController!.activeUser.value!.activeStatus,
            ),
            Container(
              margin: EdgeInsets.only(
                left: chatMessage.fromId.toString() ==
                        _chatOpenController!.id.value
                    ? 10
                    : 35,
                right: chatMessage.fromId.toString() ==
                        _chatOpenController!.id.value
                    ? 10
                    : 35,
              ),
              child: Text(
                "${timeago.format(chatMessage.createdAt!)}",
                textAlign: chatMessage.fromId.toString() ==
                        _chatOpenController!.id.value
                    ? TextAlign.right
                    : TextAlign.left,
                style: Get.textTheme.subtitle1!.copyWith(
                  color: Colors.grey.shade200,
                  fontSize: 8.sp,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(
                left: chatMessage.fromId.toString() ==
                        _chatOpenController!.id.value
                    ? 10
                    : 35,
                right: chatMessage.fromId.toString() ==
                        _chatOpenController!.id.value
                    ? 10
                    : 35,
              ),
              width: Get.width * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _chatOpenController!.selectedChatMsg.value = chatMessage;
                        setState(() {
                          replyClick = true;
                        });
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.question_answer_outlined,
                            color: Get.theme.primaryColor,
                            size: 20.sp,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "Quote",
                            style: Get.textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        onForwardClick(
                          context: context,
                          showActions: false,
                          chatMessage: chatMessage,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.forward_to_inbox,
                            color: Get.theme.primaryColor,
                            size: 20.sp,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "Forward",
                            style: Get.textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  chatMessage.fromId.toString() == _chatOpenController!.id.value
                      ? Divider()
                      : SizedBox.shrink(),
                  chatMessage.fromId.toString() == _chatOpenController!.id.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              // Logger.warn(chatMessage.id);
                              await source!
                                  .deleteSingleMessage(chatMessage)
                                  .then((value) => Get.back());
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "Delete",
                                  style: Get.textTheme.subtitle2,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Get.back(),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Container(
                    color: Colors.black12,
                  ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutBack,
                builder: (context, val, child) => Transform.scale(
                  scale: val,
                  child: child,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize chatAppBarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.h),
      child: Container(
        height: 100.h,
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF93CFC4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 70.h,
                      width: 70.w,
                      child: IconButton(
                        tooltip: 'Back',
                        icon: Icon(
                          Icons.arrow_back,
                          size: ScreenUtil().setSp(20),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  widget.avatarUrl == "" || widget.avatarUrl == null
                      ? CachedNetworkImage(
                          imageUrl:
                              "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg",
                          imageBuilder: (context, imageProvider) => Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              "${AppConfig.domainName}/${widget.avatarUrl}",
                          imageBuilder: (context, imageProvider) => Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return !_pusherController.isTyping.value
                              ? Text(
                                  "${widget.chatTitle}",
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                )
                              : Text(
                                  "${widget.chatTitle} is typing",
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                );
                        }),
                        getStatusTitle(widget.onlineStatus) != ""
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color:
                                          getOnlineColor(widget.onlineStatus),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    getStatusTitle(widget.onlineStatus),
                                    style: Get.textTheme.subtitle1!.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (_chatOpenController!.isLoading.value) {
                      return Container();
                    } else {
                      if (_chatOpenController!.activeUser.value!.block!) {
                        return PopupMenuButton(
                          onSelected: (dynamic value) async {
                            if (value == 1) {
                              Get.to(
                                () => ChatFilesPage(
                                  chatId: widget.userId.toString(),
                                  isGroup: false,
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Files"),
                              value: 1,
                            ),
                          ],
                        );
                      } else {
                        return PopupMenuButton(
                          onSelected: (dynamic value) async {
                            if (value == 1) {
                              Get.to(
                                () => ChatFilesPage(
                                  chatId: widget.userId.toString(),
                                  isGroup: false,
                                ),
                              );
                            } else if (value == 2) {
                              await _chatOpenController!.blockUser("block");
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Files"),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Text("Block User"),
                              value: 2,
                            ),
                          ],
                        );
                      }
                    }
                  })
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }
}

class MessageItemWidget extends StatelessWidget {
  final ChatMessage? chatMessage;
  final String? name;
  final String? avatarUrl;
  final String? currentUserId;
  final bool? menuVisible;
  final bool? showActions;
  final Function? onTapMenu;
  final int? activeStatus;
  MessageItemWidget({
    this.chatMessage,
    this.name,
    this.avatarUrl,
    this.currentUserId,
    this.menuVisible,
    this.showActions,
    this.onTapMenu,
    required this.activeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: menuVisible! ? 10 : 5,
        bottom: menuVisible! ? 10 : 5,
      ),
      child: Row(
        mainAxisAlignment: chatMessage!.fromId.toString() != currentUserId
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: chatMessage!.fromId.toString() != currentUserId
                ? CachedNetworkImage(
                    imageUrl: "${AppConfig.domainName}/$avatarUrl",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 25.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Image.network(
                      "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg",
                      width: 20.w,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(
            width: 5,
          ),
          chatMessage != null
              ? ChatMessageWidget(
                  name: name,
                  chatMessage: chatMessage,
                  id: int.parse(currentUserId!),
                  menuVisible: menuVisible,
                  onTapMenu: onTapMenu,
                  showActions: showActions,
                  activeStatus: activeStatus,
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
