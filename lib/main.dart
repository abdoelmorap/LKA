import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:khalti/khalti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/widget/page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

var language;
bool langValue = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Color(0xff93cfc4), //or set color with: Color(0xFF0000FF)
  ));
  HttpOverrides.global = new MyHttpOverrides();
  final sharedPref = await SharedPreferences.getInstance();
  language = sharedPref.getString('language');
  print(language);
  await Khalti.init(
    publicKey: '$khaltiPublicKey',
    enabledDebugging: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MainPage();
  }
}
