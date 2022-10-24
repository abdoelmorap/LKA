// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/UserNotifications.dart';

class NotificationController extends GetxController {
  Rx<String> _token = "".obs;

  Rx<String> get token => this._token;

  Rx<String> _id = "".obs;

  Rx<String> get id => this._id;

  Rx<UserNotificationList> userNotificationList = UserNotificationList().obs;

  Rx<bool> isLoading = false.obs;

  Rx<int> notificationCount = 0.obs;

  Future<UserNotificationList> getNotifications() async {
    await getIdToken();
    try{
      isLoading(true);
      final response = await http.get(Uri.parse(InfixApi.getMyNotifications(_id)),
          headers: Utils.setHeader(_token.toString()));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        userNotificationList.value =
            UserNotificationList.fromJson(jsonData['data']['notifications']);
        notificationCount.value = jsonData['data']['unread_notification'];
        return userNotificationList.value;
      } else {
        isLoading(false);
        throw Exception('failed to load');
      }
    }catch (e){
      isLoading(false);
      throw Exception('${e.toString()}');
    }finally{
      isLoading(false);
    }
  }

  Future readNotification(int notificationId) async {
    await getIdToken();
    var response = await http.get(
        Uri.parse(InfixApi.readMyNotifications(_id.value, notificationId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      Map<String, dynamic> notifications = jsonDecode(response.body) as Map;
      bool status = notifications['data']['status'];
      return status;
    } else {
      print('Error retrieving from api');
    }
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('id').then((value) {
        _id.value = value;
      });
    });
  }

  @override
  void onInit() {
    getNotifications();

    super.onInit();
  }
}
