import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/chat/controller/chat_controller.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';
import 'package:infixedu/utils/permission_check.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:let_log/let_log.dart';

class CreateGroupPage extends StatefulWidget {
  final List<ChatUser> chatUsers;
  CreateGroupPage({this.chatUsers});
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupNameController = TextEditingController();

  final ChatController _chatController = Get.put(ChatController());

  Map<ChatUser, bool> values = {};

  List<int> tmpArray = [];

  List<ChatUser> selectedUsers = [];

  final _formKey = GlobalKey<FormState>();

  DIO.Dio dio = new DIO.Dio();

  File _file;
  Future pickDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path);
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  @override
  void initState() {
    PermissionCheck().checkPermissions(context);
    widget.chatUsers.forEach((element) {
      final Map<ChatUser, bool> mapEntry = {element: false};
      values.addAll(mapEntry);
    });
    super.initState();
  }

  bool isResponse = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: "Create Group",
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Text(
                  "Group Name",
                  style: Get.textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.headline6,
                  controller: groupNameController,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Text(
                  "Group Photo",
                  style: Get.textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: InkWell(
                  onTap: pickDocument,
                  child: TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.headline6,
                    autovalidateMode: AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      labelText: _file == null
                          ? 'Select image'
                          : _file.path.split('/').last,
                      errorStyle:
                          TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              _file == null
                  ? SizedBox.shrink()
                  : Image.file(
                      _file,
                      width: Get.width * 0.1,
                      height: Get.height * 0.1,
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Text(
                  "Select Group Members",
                  style: Get.textTheme.headline6,
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: values.keys.map((ChatUser key) {
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          child: FancyShimmerImage(
                            imageUrl:
                                "${AppConfig.domainName}/${key.avatarUrl}",
                            boxFit: BoxFit.contain,
                            errorWidget: FancyShimmerImage(
                              imageUrl:
                                  "${AppConfig.domainName}/public/chat/images/bw-spondon-icon.png",
                              boxFit: BoxFit.contain,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("${key.fullName ?? "${key.username}"}"),
                      ],
                    ),
                    value: values[key],
                    activeColor: Get.theme.primaryColor,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        values[key] = value;
                      });
                      tmpArray.clear();
                      selectedUsers.clear();
                      values.forEach((key, value) {
                        if (value == true) {
                          tmpArray.add(key.id);
                          selectedUsers.add(key);
                        } else {
                          tmpArray.remove(key.id);
                          selectedUsers.remove(key);
                        }
                      });
                      print(tmpArray.toSet().toList());
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: !isResponse
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: Get.width * 0.5,
                    height: 40.0,
                    child: DecoratedBox(
                        decoration: Utils.gradientBtnDecoration,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (_file == null) {
                                  Utils.showToast("Please add a group photo");
                                  return;
                                } else {
                                  if (tmpArray.length == 0) {
                                    Utils.showToast(
                                        "Please add some group members");
                                    return;
                                  } else {
                                    setState(() {
                                      isResponse = true;
                                    });

                                    // var stream = new http.ByteStream(
                                    //     DelegatingStream.typed(
                                    //         _file.openRead()));
                                    // var length = await _file.length();

                                    // var uri =
                                    //     Uri.parse(InfixApi.chatGroupCreate);

                                    // var request =
                                    //     new http.MultipartRequest("POST", uri);
                                    // var multipartFile = new http.MultipartFile(
                                    //     'group_photo', stream, length,
                                    //     filename: PATH.basename(_file.path));
                                    // //contentType: new MediaType('image', 'png'));

                                    // // request.files.add(multipartFile);

                                    // request.fields.addAll({
                                    //   "name": groupNameController.text,
                                    //   "users":
                                    //       tmpArray.toSet().toList().toString(),
                                    // });
                                    // request.headers.addAll(Utils.setHeader(
                                    //     _chatController.token.value
                                    //         .toString()));
                                    // var resp = await request.send();
                                    // print(resp.statusCode);
                                    // resp.stream
                                    //     .transform(utf8.decoder)
                                    //     .listen((value) {
                                    //   print(value);
                                    // });

                                    // setState(() {
                                    //   isResponse = false;
                                    // });

                                    // return;

                                    var data = {
                                      "name": groupNameController.text,
                                      "users[]": tmpArray,
                                      "created_by": _chatController.id.value,
                                      "group_photo":
                                          await DIO.MultipartFile.fromFile(
                                              _file.path),
                                    };
                                    print(data);
                                    DIO.FormData formData =
                                        DIO.FormData.fromMap({
                                      "name": groupNameController.text,
                                      "users[]": tmpArray,
                                      "created_by": _chatController.id.value,
                                      "group_photo":
                                          await DIO.MultipartFile.fromFile(
                                              _file.path),
                                    });
                                    var response = await dio.post(
                                      InfixApi.chatGroupCreate,
                                      data: formData,
                                      options: DIO.Options(
                                        headers: {
                                          "Accept": "application/json",
                                          "Authorization": _chatController
                                              .token.value
                                              .toString(),
                                        },
                                      ),
                                      onSendProgress: (received, total) {
                                        if (total != -1) {
                                          print((received / total * 100)
                                                  .toStringAsFixed(0) +
                                              '%');
                                        }
                                      },
                                    ).catchError((e) {
                                      final errorMessage =
                                          DioExceptions.fromDioError(e)
                                              .toString();
                                      setState(() {
                                        isResponse = false;
                                      });
                                      Utils.showToast(errorMessage);
                                    });

                                    Logger.log(response.statusCode);
                                    Logger.log(response.data);
                                    if (response.statusCode == 200) {
                                      Utils.showToast(
                                          '${response.data['success']}');

                                      _chatController.chatModel.value.groups
                                          .clear();

                                      await _chatController.getAllChats();
                                      setState(() {
                                        isResponse = false;
                                      });
                                      Get.back();
                                    } else {
                                      setState(() {
                                        isResponse = false;
                                      });
                                    }
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              "Create",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: Colors.white),
                            ))),
                  ),
                )
              : Container(
                  width: Get.width * 0.5,
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ));
  }
}
