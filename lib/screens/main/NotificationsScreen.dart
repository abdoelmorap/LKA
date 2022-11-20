// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/server/LogoutService.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  final String id;

  NotificationScreen(this.id);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  Future readAll() async {
    controller.userNotificationList.value.userNotifications
        .forEach((element) async {
      await controller.readNotification(element.id).then((value) {
        if (value == true) {
          controller.userNotificationList.value.userNotifications
              .remove(element);
        }
      }).then((value) async {
        await controller.getNotifications();
      });
    });
    // await controller.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(
                color: Color(0xFF93CFC4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 25.w,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text(
                        "Notification".tr,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 18.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.dialog(LogoutService().logoutDialog());
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      size: 25.sp,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getNotifications();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Text(
                          "You have".tr +
                              " ${controller.notificationCount.value} " +
                              "New notification".tr,
                        );
                      }),
                    ),
                    ElevatedButton(
                      onPressed: readAll,
                      child: Text(
                        'Mark all as read'.tr,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.white,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (controller.userNotificationList.value.userNotifications
                            .length ==
                        0) {
                      return Center(
                        child: Container(
                          child: Text(
                            "No new notifications".tr,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: false,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10.h,
                          );
                        },
                        itemCount: controller.userNotificationList.value
                            .userNotifications.length,
                        itemBuilder: (context, index) {
                          final item = controller.userNotificationList.value
                              .userNotifications[index];
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.solidBell,
                                    color: Colors.deepPurple,
                                    size: 15.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.message,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              fontSize: ScreenUtil().setSp(13),
                                            ),
                                      ),
                                      Text(
                                        timeago.format(item.createdAt),
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              fontSize: ScreenUtil().setSp(12),
                                            ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Mark as Read',
                                color: Colors.deepPurple,
                                iconWidget: Icon(
                                  Icons.panorama_fish_eye,
                                  size: 1,
                                ),
                                onTap: () async {
                                  await controller
                                      .readNotification(item.id)
                                      .then((value) async {
                                    if (value == true) {
                                      controller.userNotificationList.value
                                          .userNotifications
                                          .removeAt(index);
                                    }
                                  }).then((value) async {
                                    await controller.getNotifications();
                                  });
                                },
                              ),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Mark as Read',
                                color: Colors.deepPurple,
                                iconWidget: Icon(
                                  Icons.panorama_fish_eye,
                                  size: 1,
                                ),
                                onTap: () async {
                                  await controller
                                      .readNotification(item.id)
                                      .then((value) async {
                                    if (value == true) {
                                      controller.userNotificationList.value
                                          .userNotifications
                                          .removeAt(index);
                                    }
                                  }).then((value) async {
                                    await controller.getNotifications();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                }),
              ),
            ],
          ),
        ));
  }
}
