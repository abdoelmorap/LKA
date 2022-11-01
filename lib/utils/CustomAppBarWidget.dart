// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/server/LogoutService.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/main.dart';
import 'package:infixedu/screens/ChangePassword.dart';
import 'package:infixedu/screens/student/Profile.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/UserNotifications.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget({this.title});

  String? title;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  int i = 0;
  Future? notificationCount;

  int? rtlValue;
  String? email;
  String? password;
  String? rule;
  String? _id;
  String? schoolId;
  String? isAdministrator;
  String? _token;

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  buildNotificationDialog(context, String id) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration:
                      BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple,
                      blurRadius: 20.0,
                    ),
                  ]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 20.0, right: 15.0),
                      child: FutureBuilder<UserNotificationList>(
                          future: getNotifications(int.parse(id)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              if (snapshot.data!.userNotifications!.length == 0) {
                                return Container(
                                  child: Text(
                                    "No new notifications",
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: false,
                                        itemCount: snapshot
                                            .data!.userNotifications!.length,
                                        itemBuilder: (context, index) {
                                          final item = snapshot
                                              .data!.userNotifications![index];
                                          return Material(
                                            color: Colors.transparent,
                                            clipBehavior: Clip.antiAlias,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Dismissible(
                                                key: Key(item.id.toString()),
                                                background: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.purpleAccent,
                                                          Colors
                                                              .deepPurpleAccent
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 6,
                                                        offset: Offset(1,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onDismissed: (direction) async {
                                                  var response = await http.get(
                                                      Uri.parse(InfixApi
                                                          .readMyNotifications(
                                                              int.parse(id),
                                                              snapshot
                                                                  .data!
                                                                  .userNotifications![
                                                                      index]
                                                                  .id)),
                                                      headers: Utils.setHeader(
                                                          _token.toString()));

                                                  if (response.statusCode ==
                                                      200) {
                                                    Map<String, dynamic>
                                                        notifications =
                                                        (jsonDecode(
                                                                response.body)
                                                            as Map) as Map<String, dynamic>;
                                                    bool? status =
                                                        notifications['data']
                                                            ['status'];
                                                    if (status == true) {
                                                      setState(() {
                                                        print("Index :$index");
                                                        snapshot.data!
                                                            .userNotifications!
                                                            .removeAt(index);
                                                      });
                                                    }
                                                  } else {
                                                    print(
                                                        'Error retrieving from api');
                                                  }
                                                  setState(() {
                                                    notificationCount =
                                                        getNotificationCount(
                                                            int.parse(_id!));
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "${item.message} read")));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      FontAwesomeIcons
                                                          .solidBell,
                                                      color: Colors.red,
                                                      size: ScreenUtil()
                                                          .setSp(15),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.message!,
                                                          textAlign:
                                                              TextAlign.end,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5!
                                                                  .copyWith(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            13),
                                                                  ),
                                                        ),
                                                        Text(
                                                          timeago.format(
                                                              item.createdAt!),
                                                          textAlign:
                                                              TextAlign.end,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5!
                                                                  .copyWith(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                  ),
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        snapshot.data!.userNotifications!
                                            .forEach((element) async {
                                          var response = await http.get(
                                              Uri.parse(
                                                  InfixApi.readMyNotifications(
                                                      int.parse(id),
                                                      element.id)),
                                              headers: Utils.setHeader(
                                                  _token.toString()));
                                          if (response.statusCode == 200) {
                                            Map<String, dynamic> notifications =
                                                (jsonDecode(response.body)
                                                    as Map) as Map<String, dynamic>;
                                            bool? status =
                                                notifications['data']['status'];
                                            if (status == true) {
                                              setState(() {
                                                print("Index :${element.id}");
                                              });
                                            }
                                          } else {
                                            print('Error retrieving from api');
                                          }
                                        });
                                        setState(() {
                                          notificationCount =
                                              getNotificationCount(
                                                  int.parse(_id!));
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text(
                                        'Mark all as read',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                              fontSize: ScreenUtil().setSp(12),
                                              color: Colors.white,
                                            ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return Center(
                                  child: CupertinoActivityIndicator());
                            }
                          }),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.red,
            ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.green,
            ),
      ),
      onPressed: () async {
        Utils.clearAllValue();
        Utils.saveIntValue('locale', rtlValue!);
        Route route = MaterialPageRoute(builder: (context) => MyApp());
        Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));

        var response = await http.post(Uri.parse(InfixApi.logout()),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
        } else {
          Utils.showToast('Unable to logout');
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Logout",
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Text("Would you like to logout?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showStudentProfileDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      shape: BoxShape
                          .rectangle, // BoxShape.circle or BoxShape.retangle
                      //color: const Color(0xFF66BB6A),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple,
                          blurRadius: 20.0,
                        ),
                      ]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 20.0, right: 15.0),
                        child: ListView(
                          children: <Widget>[
                            InkWell(
                              child: SizedBox(
                                child: Text(
                                  "Profile",
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  ScaleRoute(
                                    page: Profile(
                                      id: _id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(ScaleRoute(page: ChangePassword()));
                              },
                              child: SizedBox(
                                child: Text(
                                  "Change Password",
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                            InkWell(
                              child: SizedBox(
                                child: Text(
                                  "Logout",
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              onTap: () {
                                showAlertDialog(context);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showOthersProfileDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      shape: BoxShape
                          .rectangle, // BoxShape.circle or BoxShape.retangle
                      //color: const Color(0xFF66BB6A),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade300,
                          blurRadius: 20.0,
                        ),
                      ]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 20.0, right: 15.0),
                      child: ListView(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(ScaleRoute(page: ChangePassword()));
                            },
                            child: Text(
                              "Change Password",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            child: Text(
                              "Logout",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onTap: () {
                              showAlertDialog(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget getProfileImage(
      BuildContext context, String email, String password, String rule) {
    return FutureBuilder(
      future: Utils.getStringValue('image'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          // print('Profile Image: ${snapshot.data}');
          Utils.saveStringValue('image', snapshot.data!);
          return GestureDetector(
            onTap: () {
              rule == '2'
                  ? showStudentProfileDialog(context)
                  : showOthersProfileDialog(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: ScreenUtil().setSp(22),
                child: CachedNetworkImage(
                  imageUrl: InfixApi.root + snapshot.data!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  placeholder: (context, url) => CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => CachedNetworkImage(
                    imageUrl:
                        InfixApi.root + 'public/uploads/staff/demo/staff.jpg',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              rule == '2'
                  ? showStudentProfileDialog(context)
                  : showOthersProfileDialog(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 22,
                child: CachedNetworkImage(
                  imageUrl: "https://i.imgur.com/7PqjiH7.jpeg",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  placeholder: (context, url) => CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> getImageUrl(String email, String password, String rule) async {
    var image = 'http://saskolhmg.com/images/studentprofile.png';

    var response = await http.get(Uri.parse(InfixApi.login(email, password)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic>? user = (jsonDecode(response.body) as Map?) as Map<String, dynamic>?;
      if (rule == '2')
        image = InfixApi.root + user!['data']['userDetails']['student_photo'];
      else if (rule == '3')
        image = InfixApi.root + user!['data']['userDetails']['fathers_photo'];
      else
        image = InfixApi.root + user!['data']['userDetails']['staff_photo'];
    }
    return image == InfixApi.root
        ? 'http://saskolhmg.com/images/studentprofile.png'
        : '$image';
  }

  Future<int?> getNotificationCount(int id) async {
    int? count = 0;

    var response = await http.get(Uri.parse(InfixApi.getMyNotifications(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic> notifications = (jsonDecode(response.body) as Map) as Map<String, dynamic>;
      count = notifications['data']['unread_notification'];
      // count = 120;
    } else {
      print('Error retrieving from api');
      count = 0;
    }
    return count;
  }

  Future<UserNotificationList> getNotifications(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getMyNotifications(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UserNotificationList.fromJson(jsonData['data']['notifications']);
    } else {
      throw Exception('failed to load');
    }
  }

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    Utils.getStringValue('email').then((value) {
      email = value;
    });
    Utils.getStringValue('password').then((value) {
      password = value;
    });
    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });
    Utils.getStringValue('rule').then((value) {
      rule = value;
    });
    Utils.getStringValue('id').then((value) {
      _id = value;
      // notificationCount = getNotificationCount(int.parse(_id));
    });
    Utils.getStringValue('isAdministrator').then((value) {
      isAdministrator = value;
    });
    Utils.getIntValue('locale').then((value) {
      setState(() {
        rtlValue = value;
      });
    });
    super.initState();
  }

  logoutDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.red,
            ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.green,
            ),
      ),
      onPressed: () async {
        Utils.clearAllValue();
        Route route = MaterialPageRoute(
            builder: (context) => MyApp(), fullscreenDialog: true);
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, ModalRoute.withName('/'));
        var response = await http.post(Uri.parse(InfixApi.logout()),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
        } else {
          Utils.showToast('Unable to logout');
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Logout",
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Text("Would you like to logout?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (i < 1) {
            //if you don't set any condition here setState call again and again
            Utils.getStringValue('lang').then((value) {
              if (value == null) {
                Utils.getTranslatedLanguage('en', widget.title).then((val) {
                  print(val);
                  setState(() => widget.title = val);
                  i++;
                });
              } else {
                Utils.getTranslatedLanguage(value, widget.title).then((val) {
                  print(val);
                  setState(() => widget.title = val);
                  i++;
                });
              }
            });
          }
          return AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   // image: AssetImage(AppConfig.appToolbarBackground),
                //   fit: BoxFit.fill,
                // ),
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
                            navigateToPreviousPage(context);
                          }),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text(
                        widget.title!,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
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
          );
        },
      ),
    );
  }
}
