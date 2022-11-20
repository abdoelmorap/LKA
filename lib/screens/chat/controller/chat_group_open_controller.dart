import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infixedu/screens/chat/controller/chat_controller.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/chat/models/ChatGroupOpenModel.dart';
import 'package:infixedu/screens/chat/models/GroupThread.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/screens/chat/models/ChatUser.dart';
import 'package:let_log/let_log.dart';

class ChatGroupOpenController extends GetxController {
  final String groupId;
  ChatGroupOpenController(this.groupId);
  var isLoading = false.obs;

  RxList<GroupThread> chatMsgSearch = <GroupThread>[].obs;

  Rx<bool> courseSearchStarted = false.obs;

  Rx<GroupThread> selectedChatMsg = GroupThread().obs;

  Rx<String> _token = "".obs;
  Rx<String> get token => this._token;

  Rx<String> _id = "".obs;
  Rx<String> get id => this._id;

  Rx<String> imageUrl = "".obs;

  Rx<int> lastThreadId = 0.obs;

  RxList<int> msgIds = <int>[].obs;

  Rx<ChatGroupOpenModel> chatGroupModel = ChatGroupOpenModel().obs;

  Rx<ChatUser> selectedUser = ChatUser().obs;

  Rx<GroupRole> selectedGroupRole = GroupRole().obs;

  final List<GroupRole> groupRoles = [
    GroupRole(name: "User", role: 0),
    GroupRole(name: "Admin", role: 1),
    GroupRole(name: "Moderator", role: 2),
  ];

  Future getIdToken() async {
    isLoading(true);
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('id').then((value) async {
        _id.value = value;
        await Utils.getStringValue('image').then((image) async {
          imageUrl.value = image;

          // isLoading(false);
        });
      });
    });
  }

  Future<ChatGroupOpenModel> getAll() async {
    Logger.warn(groupId);
    ChatGroupOpenModel sourceData;
    try {
      final result = await http.get(
        Uri.parse("${InfixApi.chatGroupOpen}/$groupId"),
        headers: Utils.setHeader(token.toString()),
      );
      if (result.statusCode == 200) {
        final resultData = jsonDecode(result.body);

        sourceData = ChatGroupOpenModel.fromJson(resultData);

        Logger.warn("MY ROLE => ${sourceData.group.toJson().toString()}");

        chatGroupModel.value = sourceData;

        selectedUser.value = chatGroupModel.value.group.users.first;

        selectedGroupRole.value = groupRoles.first;

        Logger.error(sourceData.group.users.length);

        // if (sourceData.group.threads.length > 0) {
        //   lastThreadId.value = sourceData.group.threads.first.id;
        // }
      }
    } catch (e) {
      throw e.toString();
    } finally {
      isLoading(false);
    }
    return sourceData;
  }

  RxList<ChatUser> members = <ChatUser>[].obs;

  Rx<ChatUser> selectedAddUser = ChatUser().obs;

  void getAddPeopleDialog() {
    members.clear();
    final ChatController _chatController = Get.put(ChatController());

    List<int> usersOne = [];
    List<int> usersTwo = [];

    _chatController.chatModel.value.users.forEach((users) {
      usersOne.add(users.id);
    });
    chatGroupModel.value.group.users.forEach((groupUsers) {
      usersTwo.add(groupUsers.id);
    });
    usersOne.removeWhere((element) => usersTwo.contains(element));
    _chatController.chatModel.value.users.forEach((element) {
      if (usersOne.contains(element.id)) {
        members.add(element);
      }
    });
    if (members.length > 0) {
      selectedAddUser.value = members.first;
    }
  }

  Future chatGroupSetRead(type) async {
    EasyLoading.show(status: 'Updating...');
    try {
      Map jsonData = {
        "type": type,
        "group_id": groupId,
      };

      final response = await http.post(
        Uri.parse(InfixApi.chatGroupSetReadOnly),
        body: jsonEncode(jsonData),
        headers: Utils.setHeader(_token.toString()),
      );

      if (response.statusCode == 200) {
        await getAll();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      Utils.showToast(e.toString());
      EasyLoading.dismiss();
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future assignRole() async {
    EasyLoading.show(status: 'Updating...');
    try {
      Map jsonData = {
        "role_id": selectedGroupRole.value.role,
        "group_id": groupId,
        "user_id": selectedUser.value.id,
      };

      print(jsonData);

      final response = await http.post(
        Uri.parse(InfixApi.chatGroupAssignRole),
        body: jsonEncode(jsonData),
        headers: Utils.setHeader(_token.toString()),
      );

      if (response.statusCode == 200) {
        print(response.body);
        await getAll();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future deleteChatGroup(groupId) async {
    try {
      await getIdToken().then((value) async {
        final response = await http.post(Uri.parse(InfixApi.chatGroupDelete),
            headers: Utils.setHeader(_token.toString()),
            body: jsonEncode(
              {
                'group_id': groupId,
              },
            ));
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          if (jsonData['notPermitted'] == false) {
            final ChatController _chatController = Get.put(ChatController());
            await _chatController.getAllChats().then((value) => Get.back());
          } else {
            Utils.showToast("You are not allowed to delete this chat");
          }
        } else {
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      throw Exception('${e.toString()}');
    } finally {}
  }

  Future removePeople(userId) async {
    EasyLoading.show(status: 'Removing...');
    try {
      Map jsonData = {
        "user_id": userId,
        "group_id": groupId,
      };

      print(jsonData);

      final response = await http.post(
        Uri.parse(InfixApi.groupRemovePeople),
        body: jsonEncode(jsonData),
        headers: Utils.setHeader(_token.toString()),
      );

      if (response.statusCode == 200) {
        Logger.warn(response.body);
        await getAll();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future addPeople() async {
    EasyLoading.show(status: 'Updating...');
    try {
      Map jsonData = {
        "group_id": groupId,
        "user_id": selectedAddUser.value.id,
      };

      print(jsonData);

      final response = await http.post(
        Uri.parse(InfixApi.groupAddPeople),
        body: jsonEncode(jsonData),
        headers: Utils.setHeader(_token.toString()),
      );

      print(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        await getAll();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future leaveGroup() async {
    EasyLoading.show(status: 'Leaving...');
    try {
      Map jsonData = {
        "group_id": groupId,
        "user_id": id.value,
      };

      print(jsonData);

      final response = await http.post(
        Uri.parse(InfixApi.chatGroupLeave),
        body: jsonEncode(jsonData),
        headers: Utils.setHeader(_token.toString()),
      );

      print(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        final ChatController _chatController = Get.put(ChatController());
        await _chatController.getAllChats().then((value) => Get.back());
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future forwardMessage(Map data, bool isGroup) async {
    EasyLoading.show(status: 'Sending...');
    try {
      final response = await http.post(
        Uri.parse(
          isGroup
              ? InfixApi.chatGroupForwardMessage
              : InfixApi.chatSingleForwardMessage,
        ),
        body: jsonEncode(data),
        headers: Utils.setHeader(token.value.toString()),
      );

      print(response.body);

      if (response.statusCode == 200) {
        print(response.body);
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
    getIdToken().then((value) async => await getAll());

    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<ChatGroupOpenController>();
    super.onClose();
  }
}

class GroupRole {
  final int role;
  final String name;

  GroupRole({this.role, this.name});
}
