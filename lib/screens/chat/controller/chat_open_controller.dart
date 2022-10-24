import 'dart:async';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/chat/models/ChatMessage.dart';
import 'package:infixedu/screens/chat/models/ChatMessageOpenModel.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/screens/chat/models/ChatUser.dart';

class ChatOpenController extends GetxController {
  final int userId;
  ChatOpenController(this.userId);

  Rx<bool> isLoading = false.obs;

  Rx<String> _token = "".obs;

  Rx<String> get token => this._token;

  Rx<String> _id = "".obs;

  Rx<String> get id => this._id;

  Rx<ChatMessageOpenModel> chatOpenModel = ChatMessageOpenModel().obs;

  Rx<ChatLoadMoreModel> chatLoadMoreModel = ChatLoadMoreModel().obs;

  Rx<String> imageUrl = "".obs;

  var lastConversationId = 0.obs;

  // Rx<bool> hasNewMsg = false.obs;

  Rx<ChatMessage> selectedChatMsg = ChatMessage().obs;

  RxList<int> msgIds = <int>[].obs;

  var loadMore = false.obs;

  RxList<MapEntry<String, ChatMessage>> chatMsgSearch =
      <MapEntry<String, ChatMessage>>[].obs;

  Rx<bool> courseSearchStarted = false.obs;

  Rx<ChatUser> activeUser = ChatUser().obs;

  Future<ChatMessageOpenModel> getChatOpen() async {
    try {
      isLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(InfixApi.getChatOpen + "/$userId"),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          chatOpenModel.value = ChatMessageOpenModel.fromJson(jsonData);
          activeUser.value = chatOpenModel.value.activeUser;
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
    return chatOpenModel.value;
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('id').then((value) async {
        _id.value = value;
        await Utils.getStringValue('image').then((image) {
          imageUrl.value = image;
        });
      });
    });
  }

  // Stream<dynamic> getPeriodicStream() async* {
  //   print(1);
  //   yield* Stream.periodic(Duration(seconds: 5), (_) {
  //     print(2);
  //     checkNewMsg().then((one) {
  //       print(one);
  //     });
  //   }).asyncMap(
  //     (value) async => value,
  //   );
  // }

  Stream counterStream;
  // StreamSubscription streamSubscription;

  // void listenAfterDelay() async {
  //   counterStream =
  //       new Stream.periodic(Duration(seconds: 5), (_) => checkNewMsg());
  //   await Future.delayed(const Duration(seconds: 5));
  //   streamSubscription = counterStream.listen((value) {
  //     print('Value from controller: $value');
  //   });
  // }

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
        headers: Utils.setHeader(_token.value.toString()),
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

  Future blockUser(action) async {
    EasyLoading.show(status: 'Blocking...');
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
        await getChatOpen();
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
    getIdToken();
    getChatOpen();
    // getChatOpen().then((value) {
    //   // listenAfterDelay();
    // });
    super.onInit();
  }

  @override
  void onClose() {
    // streamSubscription.cancel();

    msgIds.clear();
    super.onClose();
  }
}
