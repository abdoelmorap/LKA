import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/chat/controller/chat_controller.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';

class BlockedUsersPage extends StatefulWidget {
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    chatController.getAllBlockedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Blocked Users",
      ),
      body: Obx(() {
        if (chatController.isBlockedUsersLoading.value) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          if (chatController.blockedUsers.length == 0) {
            return Utils.noDataWidget();
          }
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                      itemCount: chatController.blockedUsers.length,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (context, index) {
                        ChatUser chatUser = chatController.blockedUsers[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            title: Text(
                              "${chatUser.fullName ?? chatUser.email}",
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
                            trailing: GestureDetector(
                              onTap: () async {
                                await chatController.blockUser(
                                    "unblock", chatUser.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade500,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  "Unblock",
                                  style: Get.textTheme.subtitle1.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
