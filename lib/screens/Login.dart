// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/server/LoginService.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  String? user;
  String? email;
  late Future<String?> futureEmail;
  String password = '123456';
  bool isResponse = false;
  bool obscurePass = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(
      onWillPop: () async => !(Navigator.of(context).userGestureInProgress),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(AppConfig.loginBackground),
                    fit: BoxFit.fill,
                  )),
                  child: Center(
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(AppConfig.appLogo),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AppConfig.isDemo
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.h),
                        child: Row(
                          children: <Widget>[
                            // Expanded(
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       user = 'student';
                            //       futureEmail = getEmail(user);
                            //       futureEmail.then((value) {
                            //         setState(() {
                            //           email = value;
                            //           emailController.text = email;
                            //           passwordController.text = password;
                            //         });
                            //       });
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //         primary: Colors.purpleAccent,
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(8.0),
                            //             bottomLeft: Radius.circular(8.0),
                            //           ),
                            //         )),
                            //     child: Text(
                            //       "Student",
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline4
                            //           .copyWith(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // setState(() {
                                  //   user = 'teacher';
                                  //   futureEmail = getEmail(user);
                                  //   futureEmail.then((value) {
                                  //     setState(() {
                                  //       email = value;
                                  //       emailController.text = email!;
                                  //       passwordController.text = password;
                                  //     });
                                  //   });
                                  // });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xffFFD402),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(0.0),
                                      ),
                                    )),
                                child: Text("Teacher",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(color: Colors.white)),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // user = 'parent';
                                  // futureEmail = getEmail(user);
                                  // futureEmail.then((value) {
                                  //   setState(() {
                                  //     email = value;
                                  //     emailController.text = email!;
                                  //     passwordController.text = password;
                                  //   });
                                  // });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff93cfc4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    )),
                                child: Text("Parents",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.h, 0, 10.h, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: textStyle,
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Email".tr,
                      labelText: "Email".tr,
                      labelStyle: textStyle,
                      errorStyle:
                          TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: Icon(
                        Icons.email,
                        size: 24,
                        color: Color.fromRGBO(142, 153, 183, 0.5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.h, 10.h, 10.h, 0),
                  child: TextFormField(
                    obscureText: obscurePass,
                    keyboardType: TextInputType.visiblePassword,
                    style: textStyle,
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Password".tr,
                      labelText: "Password".tr,
                      labelStyle: textStyle,
                      errorStyle:
                          TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            obscurePass = !obscurePass;
                          });
                        },
                        child: Icon(
                          obscurePass ? Icons.lock_rounded : Icons.lock_open,
                          size: 24,
                          color: Color.fromRGBO(142, 153, 183, 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: Utils.gradientBtnDecoration,
                  child: Text(
                    "Login".tr,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white),
                  ),
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    String email = emailController.text;
                    String password = passwordController.text;

                    if (email.length > 0 && password.length > 0) {
                      setState(() {
                        isResponse = true;
                      });
                      Login(email, password).getLogin(context).then((result) {
                        setState(() {
                          isResponse = false;
                        });
                        Utils.showToast(result!);
                      });
                    } else {
                      setState(() {
                        isResponse = false;
                      });
                      Utils.showToast('invalid email and password');
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isResponse == true
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                      )
                    : Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getEmail(String? user) async {
    final response = await http.get(Uri.parse(InfixApi.getEmail));
    // print(response.body);
    var jsonData = json.decode(response.body);

    //print(InfixApi.getDemoEmail(schoolId));

    return jsonData['data'][user]['email'];
  }
}
