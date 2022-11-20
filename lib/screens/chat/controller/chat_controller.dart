import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infixedu/screens/chat/controller/pusher_controller.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/chat/models/ChatActiveStatus.dart';
import 'package:infixedu/screens/chat/models/ChatModelMain.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/screens/chat/models/ChatSettingsModel.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';
import 'package:infixedu/screens/chat/models/SearchChatUserModel.dart';

class ChatController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> isBlockedUsersLoading = false.obs;

  Rx<String> _token = "".obs;

  Rx<String> get token => this._token;

  Rx<String> _id = "".obs;

  Rx<String> get id => this._id;

  Rx<ChatModelMain> chatModel = ChatModelMain().obs;

  Rx<bool> isSearching = false.obs;

  Rx<bool> searchFound = false.obs;

  Rx<bool> searchClicked = false.obs;

  Rx<SearchChatUserModel> searchUserModel = SearchChatUserModel().obs;

  Rx<ChatUser> userStatus = ChatUser().obs;

  Rx<bool> isStatusLoading = false.obs;

  Rx<ChatSettingsModel> chatSettings = ChatSettingsModel().obs;

  final List<ChatStatus> chatActiveList = [
    ChatStatus(
      status: 1,
      title: "Active",
    ),
    ChatStatus(
      status: 0,
      title: "Inactive",
    ),
    ChatStatus(
      status: 2,
      title: "Away",
    ),
    ChatStatus(
      status: 3,
      title: "Busy",
    ),
  ];

  Rx<ChatStatus> selectedStatus = ChatStatus().obs;

  RxList<ChatUser> blockedUsers = <ChatUser>[].obs;

  Future<bool> changeActiveStatus(int type) async {
    bool status = false;
    try {
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(InfixApi.changeChatStatus + "/$type"),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          print(jsonData);
          // status = true;
        } else {
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      throw Exception('${e.toString()}');
    } finally {}
    return status;
  }

  Future<ChatUser> getUserStatus() async {
    try {
      isStatusLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(InfixApi.getChatStatus + "/${id.value}"),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          userStatus.value = ChatUser.fromJson(jsonData['activeUser']);

          if (userStatus.value.activeStatus == 0) {
            selectedStatus.value = chatActiveList[1];
          } else if (userStatus.value.activeStatus == 1) {
            selectedStatus.value = chatActiveList[0];
          } else if (userStatus.value.activeStatus == 2) {
            selectedStatus.value = chatActiveList[2];
          } else if (userStatus.value.activeStatus == 3) {
            selectedStatus.value = chatActiveList[3];
          }
        } else {
          isStatusLoading(false);
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      isStatusLoading(false);
      throw Exception('${e.toString()}');
    } finally {
      isStatusLoading(false);
    }
    return userStatus.value;
  }

  Future<SearchChatUserModel> searchUser(String keyword) async {
    searchUserModel.value.users?.clear();
    try {
      isSearching(true);
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(InfixApi.searchChatUser + "?keywords=$keyword"),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          searchUserModel.value = SearchChatUserModel.fromJson(jsonData);
        } else {
          isSearching(false);
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      isSearching(false);
      throw Exception('${e.toString()}');
    } finally {
      isSearching(false);
    }
    return searchUserModel.value;
  }

  Future<ChatModelMain> getAllChats() async {
    try {
      final response = await http.get(
        Uri.parse(InfixApi.getChatOpen),
        headers: Utils.setHeader(
          token.value.toString(),
        ),
      );
      if (response.statusCode == 200) {
        chatModel.value = chatModelMainFromJson(response.body);
        await getUserStatus();
      } else {
        isLoading(false);
        throw Exception('failed to load');
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    } finally {}
    return chatModel.value;
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('id').then((value) {
        _id.value = value;
      });
    });
  }

  Future getChatSettings() async {
    try {
      isLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(Uri.parse(InfixApi.chatPermissionGet),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          await changeActiveStatus(1);
          var jsonData = jsonDecode(response.body);
          chatSettings.value = ChatSettingsModel.fromJson(jsonData);

          if (chatSettings.value.chatSettings.chatMethod == 'pusher') {
            final PusherController pusherController =
                Get.put(PusherController());
            pusherController.onInit();
          }
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      isLoading(false);
      throw Exception('${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future invitation(to) async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = {"to": to};
      final response = await http.post(
        Uri.parse(
          InfixApi.chatInvitaionOpen,
        ),
        body: jsonEncode(data),
        headers: Utils.setHeader(token.value.toString()),
      );

      print(response.body);
      print(response.statusCode);

      return;
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future getAllBlockedUsers() async {
    try {
      isBlockedUsersLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(
          Uri.parse(InfixApi.chatGetBlockedUsers),
          headers: Utils.setHeader(
            _token.toString(),
          ),
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          blockedUsers.value = List<ChatUser>.from(
              jsonData["users"].map((x) => ChatUser.fromJson(x)));
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      isBlockedUsersLoading(false);
      throw Exception('${e.toString()}');
    } finally {
      isBlockedUsersLoading(false);
    }
    return blockedUsers;
  }

  Future blockUser(action, userId) async {
    EasyLoading.show(status: action + "ing...");
    try {
      final response = await http.get(
        Uri.parse(
          InfixApi.chatUserBlockAction + "/$action/$userId",
        ),
        headers: Utils.setHeader(_token.value.toString()),
      );

      print(response.body);

      if (response.statusCode == 200) {
        print(response.body);

        await getAllBlockedUsers();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onInit() {
    getChatSettings();
    super.onInit();
  }
}
