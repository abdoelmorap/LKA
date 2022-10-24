import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/chat/controller/chat_controller.dart';
import 'package:infixedu/screens/chat/controller/chat_group_open_controller.dart';
import 'package:infixedu/screens/chat/controller/pusher_controller.dart';
import 'package:infixedu/screens/chat/views/Group/ChatGroupLoadMore.dart';
import 'package:infixedu/screens/chat/views/FilePreview/ChatFilesPage.dart';
import 'package:infixedu/screens/chat/views/Group/GroupMessageWidget.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/LoadMoreIndicator.dart';
import 'package:infixedu/utils/MediaUtils.dart';
import 'package:infixedu/utils/Utils.dart';

import 'package:infixedu/screens/chat/models/ChatGroup.dart';

import 'package:infixedu/screens/chat/models/GroupThread.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';
import 'package:let_log/let_log.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:dio/dio.dart' as DIO;

class GroupChatOpenPage extends StatefulWidget {
  final String photoUrl;
  final String chatTitle;
  final String groupId;
  final ChatGroup chatGroup;
  GroupChatOpenPage(
      {this.photoUrl, this.chatTitle, this.groupId, this.chatGroup});

  @override
  _GroupChatOpenPageState createState() => _GroupChatOpenPageState();
}

class _GroupChatOpenPageState extends State<GroupChatOpenPage> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final _focusNode = FocusNode();
  ChatGroupOpenController _chatGroupOpenController;

  final TextEditingController _chatMessageCtrl = TextEditingController();

  final ScrollController scrollController = ScrollController();

  ChatController _chatController = Get.put(ChatController());

  Future chatOpen;

  bool scrolling = false;
  bool showSend = false;
  bool replyClick = false;
  bool searchClicked = false;

  ChatGroupLoadMore source;

  final TextEditingController _searchMsgCtrl = TextEditingController();

  final PusherController _pusherController = Get.put(PusherController());

  bool showMenu = false;
  bool showPortal = false;

  @override
  void initState() {
    _chatGroupOpenController = Get.put(ChatGroupOpenController(widget.groupId));

    source = ChatGroupLoadMore(widget.groupId, _chatGroupOpenController);

    _focusNode.addListener(_focusNodeListener);

    if (_chatController.chatSettings.value.chatSettings.chatMethod ==
        "pusher") {
      Future.delayed(Duration(seconds: 3), () {
        _pusherController.chatOpenGroup(widget.groupId, source);
      });
    }

    print("Group ID => ${_chatGroupOpenController.groupId}");

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

  File file;

  Future openFilePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
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
        file = File(result.files.single.path);
      });
    } else {
      Utils.showToast("Cancelled");
    }
  }

  Widget fileShowWidget() {
    if (MediaUtils.isImage(file.path)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.file(
              file,
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
    } else if (MediaUtils.isPdf(file.path)) {
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
              "${file.path.split('/').last}",
              maxLines: 1,
              style: Get.textTheme.subtitle1.copyWith(
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
    } else if (MediaUtils.isWord(file.path)) {
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
              "${file.path.split('/').last}",
              maxLines: 1,
              style: Get.textTheme.subtitle1.copyWith(
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
    } else if (MediaUtils.isVideo(file.path)) {
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
              "${file.path.split('/').last}",
              maxLines: 1,
              style: Get.textTheme.subtitle1.copyWith(
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
    source.dispose();
    _chatGroupOpenController.onClose();
    _pusherController.pusher
        .unsubscribe(channelName: 'private-group-chat' + '.${widget.groupId}');
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
          child: Obx(() {
            if (_chatGroupOpenController.isLoading.value) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              return Stack(
                children: [
                  Obx(() {
                    if (_chatController
                            .chatSettings.value.chatSettings.chatMethod !=
                        "pusher") {
                      return StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 5),
                              (_) => source.checkNewMsg()),
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
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            LoadingMoreList<GroupThread>(
                              ListConfig<GroupThread>(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                reverse: true,
                                indicatorBuilder: BuildIndicatorBuilder(
                                  source: source,
                                  isSliver: false,
                                  name: '-Start a new Conversation-'.tr,
                                ).buildIndicator,
                                addAutomaticKeepAlives: true,
                                itemBuilder: (BuildContext c,
                                    GroupThread groupThread, int index) {
                                  return GroupMessageItemWidget(
                                      groupThread: groupThread,
                                      currentUserId:
                                          _chatGroupOpenController.id.value,
                                      menuVisible: false,
                                      showActions: true,
                                      onTapMenu: () {
                                        onMenuPress(
                                          context: context,
                                          showActions: false,
                                          groupThread: groupThread,
                                        );
                                      });
                                },
                                sourceList: source,
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
                                            duration:
                                                Duration(milliseconds: 100),
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
                      _chatGroupOpenController
                                  .chatGroupModel.value.group.readOnly ==
                              0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              width: double.infinity,
                              color: Colors.white,
                              child: Column(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Replying to ${_chatGroupOpenController.selectedChatMsg.value.user.fullName} ",
                                                        style: Get
                                                            .textTheme.subtitle1
                                                            .copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${_chatGroupOpenController.selectedChatMsg.value.conversation.message}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Get
                                                            .textTheme.subtitle1
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
                                                    _chatGroupOpenController
                                                        .selectedChatMsg
                                                        .value = GroupThread();
                                                  },
                                                  child: Icon(
                                                    FontAwesomeIcons.times,
                                                    color:
                                                        Get.theme.primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox.shrink(),
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
                                                        _chatGroupOpenController
                                                            .id.value),
                                                    'to_id': int.parse(
                                                        _chatGroupOpenController
                                                            .id.value),
                                                    'user_id': int.parse(
                                                        _chatGroupOpenController
                                                            .id.value),
                                                    'message':
                                                        _chatMessageCtrl.text,
                                                    'group_id':
                                                        _chatGroupOpenController
                                                            .groupId,
                                                    'file_attach': await DIO
                                                        .MultipartFile.fromFile(
                                                      file.path,
                                                      filename: file.path
                                                          .split('/')
                                                          .last,
                                                    )
                                                  });

                                                  await source
                                                      .submitText(
                                                          hasFile: true,
                                                          formData: formData)
                                                      .then((value) {
                                                    setState(() {
                                                      _chatMessageCtrl.clear();
                                                      file = null;
                                                    });
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Obx(() {
                                          return CachedNetworkImage(
                                            imageUrl:
                                                "${AppConfig.domainName}/${_chatGroupOpenController.imageUrl.value}",
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
                                            errorWidget:
                                                (context, url, error) =>
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
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 6,
                                            minLines: 1,
                                            textInputAction:
                                                TextInputAction.newline,
                                            scrollPhysics:
                                                BouncingScrollPhysics(),
                                            style: Get.textTheme.subtitle1
                                                .copyWith(
                                              fontSize: 13,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 4),
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
                                                            'reply': _chatGroupOpenController
                                                                .selectedChatMsg
                                                                .value
                                                                .conversation
                                                                .id,
                                                            'from_id': int.parse(
                                                                _chatGroupOpenController
                                                                    .id.value),
                                                            'to_id': int.parse(
                                                                _chatGroupOpenController
                                                                    .id.value),
                                                            'user_id': int.parse(
                                                                _chatGroupOpenController
                                                                    .id.value),
                                                            'message':
                                                                _chatMessageCtrl
                                                                    .text,
                                                            'group_id':
                                                                _chatGroupOpenController
                                                                    .groupId,
                                                          };

                                                          await source
                                                              .submitText(
                                                                  data: data,
                                                                  hasFile:
                                                                      false)
                                                              .then((value) {
                                                            _chatMessageCtrl
                                                                .clear();
                                                            _chatGroupOpenController
                                                                    .selectedChatMsg
                                                                    .value =
                                                                GroupThread();
                                                          });
                                                          setState(() {
                                                            replyClick = false;
                                                          });
                                                        } else {
                                                          Map data = {
                                                            'from_id': int.parse(
                                                                _chatGroupOpenController
                                                                    .id.value),
                                                            'to_id': int.parse(
                                                                _chatGroupOpenController
                                                                    .id.value),
                                                            'user_id': int.parse(
                                                                _chatGroupOpenController
                                                                    .id.value),
                                                            'message':
                                                                _chatMessageCtrl
                                                                    .text,
                                                            'group_id':
                                                                _chatGroupOpenController
                                                                    .groupId,
                                                          };
                                                          await source
                                                              .submitText(
                                                                  data: data,
                                                                  hasFile:
                                                                      false)
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
                                                      color: Get
                                                          .theme.primaryColor,
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
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              );
            }
          }),
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
      {BuildContext context,
      bool showActions,
      GroupThread groupThread,
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
                        style: Get.textTheme.subtitle1.copyWith(
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
                      GroupMessageItemWidget(
                        groupThread: groupThread,
                        currentUserId: _chatGroupOpenController.id.value,
                        menuVisible: menuVisible,
                        showActions: showActions,
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
                            hintStyle: Get.textTheme.subtitle1.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      ListView.separated(
                          itemCount:
                              chatController.chatModel.value.users.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          padding:
                              EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          itemBuilder: (context, index) {
                            ChatUser chatUser =
                                chatController.chatModel.value.users[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${chatUser.fullName ?? ""}",
                                  style: Get.textTheme.subtitle1
                                      .copyWith(fontSize: 14),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      '${AppConfig.domainName}/${chatUser.avatarUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 30.w,
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
                                      'from_id':
                                          _chatGroupOpenController.id.value,
                                      'to_id': chatUser.id,
                                      'message': forwardMessageCtrl.text,
                                      'forward': groupThread.conversation.id,
                                    };

                                    await _chatGroupOpenController
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
                              chatController.chatModel.value.groups.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          padding:
                              EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          itemBuilder: (context, groupIndex) {
                            ChatGroup chatGroup = chatController
                                .chatModel.value.groups[groupIndex];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${chatGroup.name ?? ""}",
                                  style: Get.textTheme.subtitle1
                                      .copyWith(fontSize: 14),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      '${AppConfig.domainName}/${chatGroup.photoUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 30.w,
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
                                      'user_id':
                                          _chatGroupOpenController.id.value,
                                      'group_id': chatGroup.id,
                                      'message': forwardMessageCtrl.text,
                                      'forward': groupThread.conversation.id,
                                    };

                                    await _chatGroupOpenController
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
      {BuildContext context,
      bool showActions,
      GroupThread groupThread,
      bool menuVisible = true}) {
    final child = Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              groupThread.userId.toString() == _chatGroupOpenController.id.value
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: <Widget>[
            GroupMessageItemWidget(
              groupThread: groupThread,
              currentUserId: _chatGroupOpenController.id.value,
              menuVisible: menuVisible,
              showActions: showActions,
            ),
            Container(
              margin: EdgeInsets.only(
                left: groupThread.userId.toString() ==
                        _chatGroupOpenController.id.value
                    ? 10
                    : 35,
                right: groupThread.userId.toString() ==
                        _chatGroupOpenController.id.value
                    ? 10
                    : 35,
              ),
              child: Text(
                "${timeago.format(groupThread.createdAt)}",
                textAlign: groupThread.userId.toString() ==
                        _chatGroupOpenController.id.value
                    ? TextAlign.right
                    : TextAlign.left,
                style: Get.textTheme.subtitle1.copyWith(
                  color: Colors.grey.shade200,
                  fontSize: 8.sp,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(
                left: groupThread.userId.toString() ==
                        _chatGroupOpenController.id.value
                    ? 10
                    : 35,
                right: groupThread.userId.toString() ==
                        _chatGroupOpenController.id.value
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
                        _chatGroupOpenController.selectedChatMsg.value =
                            groupThread;
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
                          groupThread: groupThread,
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
                  groupThread.userId.toString() ==
                          _chatGroupOpenController.id.value
                      ? Divider()
                      : SizedBox.shrink(),
                  groupThread.userId.toString() ==
                          _chatGroupOpenController.id.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Logger.warn(groupThread.id);
                              source.deleteGroupMessage(groupThread.id);
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
          onTap: () {
            setState(() {
              menuVisible = false;
            });
            Get.back();
          },
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

  onAddNewMemberDialog(context) {
    _chatGroupOpenController.getAddPeopleDialog();

    print(_chatGroupOpenController.members.length);
    final child = Center(
      child: SafeArea(
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.userPlus,
                      color: Get.theme.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add People",
                      style: Get.textTheme.subtitle1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.cancel, color: Get.theme.primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _chatGroupOpenController.members.length > 0
                    ? Text(
                        "Select User",
                        style: Get.textTheme.subtitle1.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 10),
                _chatGroupOpenController.members.length > 0
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Get.theme.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                            elevation: 0,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            iconSize: 20,
                            underline: SizedBox(),
                            items: _chatGroupOpenController.members.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Row(
                                  children: [
                                    Text(
                                      item.fullName ?? item.username,
                                      style: Get.textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (ChatUser value) async {
                              _chatGroupOpenController.selectedAddUser.value =
                                  value;
                              print(_chatGroupOpenController
                                  .selectedAddUser.value.fullName);
                            },
                            value:
                                _chatGroupOpenController.selectedAddUser.value),
                      )
                    : Text(
                        "No users to add",
                        style: Get.textTheme.subtitle1,
                      ),
                SizedBox(height: 10),
                _chatGroupOpenController.members.length > 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width * 0.5,
                          height: 40.0,
                          child: DecoratedBox(
                            decoration: Utils.gradientBtnDecoration,
                            child: ElevatedButton(
                              onPressed: () => _chatGroupOpenController
                                  .addPeople()
                                  .then((value) => Get.back()),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                onSurface: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                "Submit",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
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

  openSearchDialog(context) {
    final child = Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      color: Colors.white,
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchMsgCtrl,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              minLines: 1,
              textInputAction: TextInputAction.search,
              scrollPhysics: BouncingScrollPhysics(),
              style: Get.textTheme.subtitle1.copyWith(
                fontSize: 13,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Search Messages...",
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Get.theme.primaryColor,
                ),
                onPressed: () {
                  _chatGroupOpenController.courseSearchStarted.value = true;

                  if (_searchMsgCtrl.text.isEmpty) {
                    source.refresh();
                    _chatGroupOpenController.courseSearchStarted.value = false;
                    return;
                  }

                  source.forEach((GroupThread element) {
                    if (element.conversation.message
                        .toUpperCase()
                        .contains(_searchMsgCtrl.text.toUpperCase())) {
                      _chatGroupOpenController.chatMsgSearch.add(element);
                    }
                  });
                },
                icon: Icon(Icons.search),
                label: Text("Search")),
          )
        ],
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

  openMembersDialog(context) {
    final child = Center(
      child: SafeArea(
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.people, color: Get.theme.primaryColor),
                    ),
                    Center(
                      child: Text(
                        "Members",
                        style: Get.textTheme.subtitle1.copyWith(
                          fontSize: 20,
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
                      icon: Icon(Icons.cancel, color: Get.theme.primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                      itemCount: _chatGroupOpenController
                          .chatGroupModel.value.group.users.length,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (context, index) {
                        ChatUser groupUser = _chatGroupOpenController
                            .chatGroupModel.value.group.users[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            title: Text(
                              "${groupUser.fullName ?? groupUser.email ?? ""}",
                              style: Get.textTheme.subtitle1
                                  .copyWith(fontSize: 14),
                            ),
                            leading: CachedNetworkImage(
                              imageUrl:
                                  '${AppConfig.domainName}/${groupUser.avatarUrl}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 30.w,
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
                            trailing: _chatGroupOpenController
                                        .chatGroupModel.value.myRole !=
                                    0
                                ? groupUser.id.toString() ==
                                        _chatGroupOpenController.id.value
                                    ? SizedBox.shrink()
                                    : IconButton(
                                        onPressed: () async {
                                          await _chatGroupOpenController
                                              .removePeople(groupUser.id);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                : SizedBox.shrink(),
                          ),
                        );
                      }),
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

  onUserRoleClick(context) {
    // List<ChatUser> userRoleUsers = [];
    // userRoleUsers
    //     .addAll(_chatGroupOpenController.chatGroupModel.value.group.users);
    // userRoleUsers.removeWhere((element) =>
    //     element.id.toString() == _chatGroupOpenController.id.value.toString());
    // _chatGroupOpenController.selectedUser.value = userRoleUsers.first;
    final child = Center(
      child: SafeArea(
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.people, color: Get.theme.primaryColor),
                    Text(
                      "User Role",
                      style: Get.textTheme.subtitle1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.cancel, color: Get.theme.primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Select User",
                  style: Get.textTheme.subtitle1.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    elevation: 0,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    iconSize: 20,
                    underline: SizedBox(),
                    items: _chatGroupOpenController
                        .chatGroupModel.value.group.users
                        .where((element) =>
                            element.id.toString() !=
                            _chatGroupOpenController.id.value.toString())
                        .map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Row(
                          children: [
                            Text(
                              item.fullName ?? item.username,
                              style: Get.textTheme.subtitle1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (ChatUser value) async {
                      _chatGroupOpenController.selectedUser.value = value;
                    },
                    value: _chatGroupOpenController.selectedUser.value,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Select Group Role",
                  style: Get.textTheme.subtitle1.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    elevation: 0,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    iconSize: 20,
                    underline: SizedBox(),
                    items: _chatGroupOpenController.groupRoles.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Row(
                          children: [
                            Text(
                              item.name,
                              style: Get.textTheme.subtitle1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (GroupRole value) async {
                      _chatGroupOpenController.selectedGroupRole.value = value;
                    },
                    value: _chatGroupOpenController.selectedGroupRole.value,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: Get.width * 0.5,
                    height: 40.0,
                    child: DecoratedBox(
                      decoration: Utils.gradientBtnDecoration,
                      child: ElevatedButton(
                        onPressed: () => _chatGroupOpenController
                            .assignRole()
                            .then((value) => Get.back()),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          "Submit",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
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

  PreferredSize chatAppBarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.h),
      child: Container(
          height: 100.h,
          child: Obx(() {
            if (_chatGroupOpenController.isLoading.value) {
              return Container();
            } else {
              return AppBar(
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
                                }),
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl:
                              '${AppConfig.domainName}/${widget.photoUrl}',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 30.w,
                            height: 30.h,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.group),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.chatTitle}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        fontSize: 16.sp, color: Colors.white),
                              ),
                              Text(
                                "${_chatGroupOpenController.chatGroupModel.value.group.users.length.toString()} Participants",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        _chatGroupOpenController.chatGroupModel.value.myRole ==
                                1
                            ? PopupMenuButton(
                                onSelected: (value) async {
                                  if (value == 1) {
                                    onUserRoleClick(context);
                                  } else if (value == 3) {
                                    onAddNewMemberDialog(context);
                                  } else if (value == 4) {
                                    openMembersDialog(context);
                                  } else if (value == 5) {
                                    Get.to(
                                      () => ChatFilesPage(
                                        chatId: widget.groupId.toString(),
                                        isGroup: true,
                                      ),
                                    );
                                  } else if (value == 6) {
                                    await _chatGroupOpenController.leaveGroup();
                                  } else if (value == 7) {
                                    if (_chatGroupOpenController
                                            .chatGroupModel.value.myRole ==
                                        1) {
                                      _chatGroupOpenController
                                          .deleteChatGroup(widget.groupId);
                                    }
                                  } else if (value == 8) {
                                    if (_chatGroupOpenController.chatGroupModel
                                            .value.group.readOnly ==
                                        0) {
                                      await _chatGroupOpenController
                                          .chatGroupSetRead("mark");
                                    } else if (_chatGroupOpenController
                                            .chatGroupModel
                                            .value
                                            .group
                                            .readOnly ==
                                        1) {
                                      await _chatGroupOpenController
                                          .chatGroupSetRead("unmark");
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("User Role"),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Add People"),
                                    value: 3,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Members"),
                                    value: 4,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Files"),
                                    value: 5,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Leave Group"),
                                    value: 6,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete Group"),
                                    value: 7,
                                  ),
                                  PopupMenuItem(
                                    child: _chatGroupOpenController
                                                .chatGroupModel
                                                .value
                                                .group
                                                .readOnly ==
                                            0
                                        ? Text("Mark as Read Only")
                                        : Text("Remove Read Only"),
                                    value: 8,
                                  ),
                                ],
                              )
                            : PopupMenuButton(
                                onSelected: (value) async {
                                  if (value == 2) {
                                    onAddNewMemberDialog(context);
                                  } else if (value == 3) {
                                    openMembersDialog(context);
                                  } else if (value == 4) {
                                    Get.to(
                                      () => ChatFilesPage(
                                        chatId: widget.groupId.toString(),
                                        isGroup: true,
                                      ),
                                    );
                                  } else if (value == 5) {
                                    await _chatGroupOpenController.leaveGroup();
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("Add People"),
                                    value: 2,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Members"),
                                    value: 3,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Files"),
                                    value: 4,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Leave Group"),
                                    value: 5,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              );
            }
          })),
    );
  }
}

class GroupMessageItemWidget extends StatelessWidget {
  final GroupThread groupThread;
  final String currentUserId;
  final bool menuVisible;
  final bool showActions;
  final Function onTapMenu;
  GroupMessageItemWidget(
      {this.groupThread,
      this.currentUserId,
      this.menuVisible,
      this.showActions,
      this.onTapMenu});

  onAvatarPress(BuildContext context) {
    final child = Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: groupThread.userId.toString() == currentUserId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[],
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: menuVisible ? 10 : 5,
        bottom: menuVisible ? 10 : 5,
      ),
      child: Row(
        mainAxisAlignment: groupThread.userId.toString() != currentUserId
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              onAvatarPress(context);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 4),
              child: groupThread.userId.toString() != currentUserId
                  ? CachedNetworkImage(
                      imageUrl:
                          "${AppConfig.domainName}/${groupThread.user.avatarUrl}",
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
                      placeholder: (context, url) => Container(
                        width: 25.w,
                        height: 25.h,
                      ),
                      errorWidget: (context, url, error) => Image.network(
                        "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg",
                        width: 25.w,
                        height: 25.h,
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          groupThread != null
              ? GroupMessageWidget(
                  groupThread: groupThread,
                  id: int.parse(currentUserId.toString()),
                  menuVisible: menuVisible,
                  showActions: showActions,
                  onTapMenu: onTapMenu,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
