// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/language/language_selection.dart';
import 'package:infixedu/language/translation.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/widget/Line.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'ChangePassword.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final LanguageController languageController = Get.put(LanguageController());

  List<bool> isSelected = [false, false];
  GlobalKey _scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();
    Utils.getIntValue('locale').then((value) {
      setState(() {
        // ignore: unnecessary_statements
        value != null ? isSelected[value] = true : null;
        //Utils.showToast('$value');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Settings'.tr),
      backgroundColor: Colors.white,
      key: _scaffold,
      body: ListView(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Card(
          //     child: Padding(
          //       padding: EdgeInsets.only(bottom: 10.0),
          //       child: toggleButton(context),
          //     ),
          //     elevation: 5.0,
          //   ),
          // ),
          // BottomLine(),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              showChangeLanguageAlert(_scaffold.currentContext);
            },
            leading: CircleAvatar(
              backgroundColor: Color(0xffffd402),
              child: Icon(
                Icons.language,
                color: Colors.white,
                size: ScreenUtil().setSp(16),
              ),
            ),
            title: Text(
              'Change Language'.tr,
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: GetBuilder<LanguageController>(
                init: LanguageController(),
                builder: (controller) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${controller.langName.value}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        ),
                      ));
                }),
            dense: true,
          ),
          BottomLine(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(ScaleRoute(page: ChangePassword()));
            },
            leading: CircleAvatar(
              backgroundColor: Color(0xff93CFC4),
              child: Icon(
                Icons.lock,
                color: Colors.white,
                size: ScreenUtil().setSp(16),
              ),
            ),
            title: Text(
              'Change Password'.tr,
              style: Theme.of(context).textTheme.headline6,
            ),
            dense: true,
          ),
          BottomLine(),
        ],
      ),
    );
  }

  Widget toggleButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'System Locale',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ToggleButtons(
            borderColor: Colors.deepPurple,
            fillColor: Colors.deepPurple.shade200,
            borderWidth: 2,
            selectedBorderColor: Colors.deepPurple,
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'RTL',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'popins',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'LTL',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'popins',
                  ),
                ),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                Utils.saveIntValue('locale', index);
                rebuildAllChildren(context);
                for (int i = 0; i < isSelected.length; i++) {
                  if (i == index) {
                    isSelected[i] = true;
                  } else {
                    isSelected[i] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  showChangeLanguageAlert(BuildContext? context) {
    Get.bottomSheet(
      GetBuilder<LanguageController>(
          init: LanguageController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xffDADADA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              print(languages[index].languageValue);
                              LanguageSelection.instance.drop =
                                  languages[index].languageValue;
                              final sharedPref =
                                  await SharedPreferences.getInstance();
                              sharedPref.setString(
                                  'language', languages[index].languageValue!);
                              controller.appLocale =
                                  languages[index].languageValue;
                              Get.updateLocale(
                                  Locale(controller.appLocale.toString()));
                              setState(() {
                                LanguageSelection.instance.drop =
                                    languages[index].languageValue;
                                languages.forEach((element) {
                                  if (element.languageValue ==
                                      languages[index].languageValue) {
                                    LanguageSelection.instance.langName =
                                        element.languageText;
                                  }
                                });
                                languageController.langName.value =
                                    LanguageSelection.instance.langName!;
                              });
                            },
                            child: Text(
                              languages[index].languageText!,
                              style: Get.textTheme.subtitle1,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Divider(),
                  // ListTile(
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  //   title: DropdownButton(
                  //     isExpanded: true,
                  //     items: List.generate(
                  //       languages.length,
                  //       (index) => DropdownMenuItem(
                  //         child: Text(
                  //           languages[index].languageText,
                  //           style: Theme.of(context).textTheme.headline5,
                  //         ),
                  //         value: languages[index].languageValue,
                  //       ),
                  //     ),
                  //     onChanged: (value) async {
                  //       print(value);
                  //       LanguageSelection.instance.drop = value;
                  //       final sharedPref =
                  //           await SharedPreferences.getInstance();
                  //       sharedPref.setString('language', value);
                  //       controller.appLocale = value;
                  //       Get.updateLocale(
                  //           Locale(controller.appLocale.toString()));
                  //       setState(() {
                  //         LanguageSelection.instance.drop = value;
                  //         languages.forEach((element) {
                  //           if (element.languageValue == value) {
                  //             LanguageSelection.instance.langName =
                  //                 element.languageText;
                  //           }
                  //         });
                  //         languageController.langName.value =
                  //             LanguageSelection.instance.langName;
                  //       });
                  //     },
                  //     value: LanguageSelection.instance.drop,
                  //   ),
                  // ),
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                ],
              ),
            );
          }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
    );

    // showDialog<void>(
    //   barrierDismissible: true,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.all(0),
    //           child: Container(
    //             height: MediaQuery.of(context).size.height / 3,
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.white,
    //             child: Padding(
    //               padding:
    //                   const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
    //               child: ListView.builder(
    //                 itemCount: languagesList.length,
    //                 itemBuilder: (context, index) {
    //                   return Column(
    //                     children: <Widget>[
    //                       GestureDetector(
    //                         onTap: () {
    //                           Utils.saveStringValue(
    //                               'lang', languagesMap[languagesList[index]]);
    //                           application.onLocaleChanged(
    //                               Locale(languagesMap[languagesList[index]]));
    //                           rebuildAllChildren(context);
    //                         },
    //                         child: Text(
    //                           languagesList[index],
    //                           style: Theme.of(context).textTheme.headline5,
    //                         ),
    //                       ),
    //                       BottomLine(),
    //                     ],
    //                   );
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void rebuildAllChildren(BuildContext context) {
//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (BuildContext context) {
//      return MyApp();
    Route route = MaterialPageRoute(builder: (context) => MyApp());
    Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));
  }
}
