// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:infixedu/controller/system_controller.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/Login.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: 80.0, end: 150.0).animate(controller);
    controller.forward();

    Route route;

    Future.delayed(Duration(seconds: 3), () {
      getBooleanValue('isLogged').then((value) {
        if (value) {
          final SystemController _systemController =
              Get.put(SystemController());
          _systemController.getSystemSettings();
          Utils.getStringValue('rule').then((rule) {
            Utils.getStringValue('zoom').then((zoom) {
              AppFunction.getFunctions(context, rule, zoom);
            });
          });
        } else {
          if (mounted) {
            route = MaterialPageRoute(builder: (context) => LoginScreen());
            Navigator.pushReplacement(context, route);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConfig.splashScreenBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'Welcome to'.tr,
                        style: Get.textTheme.subtitle1!.copyWith(
                          fontSize: 20,
                          color: Color(0xffFFD402),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Container(
                          height: animation.value,
                          width: animation.value,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage(
                                "assets/images/mylogo.png",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Text(
                        '${AppConfig.appName}',
                        style: Get.textTheme.subtitle1!.copyWith(
                          fontSize: 18,
                          color: Color(0xffFFD402),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 80.0, left: 40, right: 40),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
