import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:infixedu/screens/chat/controller/chat_controller.dart';
import 'package:infixedu/screens/chat/models/ChatGroupPusher.dart';
import 'package:infixedu/screens/chat/models/ChatMessage.dart';
import 'package:infixedu/screens/chat/models/GroupThread.dart';
import 'package:infixedu/screens/chat/views/Group/ChatGroupLoadMore.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../views/Single/ChatLoadMore.dart';
import 'package:http/http.dart' as http;

class PusherController extends GetxController {
  int chatOpenId;
  String chatGroupId;
  RxBool isTyping = false.obs;
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  ChatController _chatController = Get.put(ChatController());

  ChatLoadMore source;

  ChatGroupLoadMore groupSource;

  onConnectPressed() async {
    try {
      await pusher.init(
        apiKey: _chatController.chatSettings.value.chatSettings.pusherAppKey,
        cluster:
            _chatController.chatSettings.value.chatSettings.pusherAppCluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer: onAuthorizer,
        logToConsole: true,
        maxReconnectionAttempts: 0,
      );
    } catch (e) {
      log("ERROR: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    // log("onEvent: $event");
    print(event.eventName);
    if (event.eventName == "client-single-typing") {
      isTyping(true);

      Future.delayed(Duration(seconds: 1), () {
        isTyping(false);
      });
    }
    if (event.channelName == 'private-single-chat' + '.$chatOpenId' ||
        event.channelName ==
            'private-single-chat' + '.${int.parse(_chatController.id.value)}') {
      final da = jsonDecode(event.data);
      ChatMessage chatMessage = ChatMessage.fromJson(da['message']);

      if (source.length != 0) {
        source.insert(0, chatMessage);
        source.onStateChanged(source);
      }
    }

    if (event.channelName == 'private-group-chat' + '.$chatGroupId' &&
        event.eventName != 'client-typing') {
      final da = jsonDecode(event.data);
      ChatGroupPusher chatMessage = ChatGroupPusher.fromJson(da);

      GroupThread groupThread = GroupThread(
        id: chatMessage.thread.id,
        userId: chatMessage.user.id,
        conversationId: chatMessage.conversation.id,
        groupId: chatMessage.group.id,
        readAt: chatMessage.thread.readAt,
        createdAt: chatMessage.conversation.createdAt,
        conversation: chatMessage.conversation,
        user: chatMessage.user,
      );

      groupSource.insert(0, groupThread);
      groupSource.onStateChanged(groupSource);
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    Map data = {
      'socket_id': socketId,
      'channel_name': channelName,
    };

    log(data.toString());

    var result = await http.post(
      Uri.parse(InfixApi.chatBroadCastAuth),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': _chatController.token.value,
      },
      body: 'socket_id=' + socketId + '&channel_name=' + channelName,
    );
    print(result.body);
    return jsonDecode(result.body);
  }

  chatOpenSingle(id, ChatLoadMore chatLoadMore) async {
    source = chatLoadMore;
    print("source eng ${source.length}");
    chatOpenId = id;
    print("id -> $chatOpenId");
    try {
      await pusher.subscribe(
          channelName: 'private-single-chat' + '.$chatOpenId');
      await pusher.connect();
      await pusher.subscribe(
          channelName: 'private-single-chat' +
              '.${int.parse(_chatController.id.value)}');
      await pusher.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  chatOpenGroup(id, ChatGroupLoadMore chatLoadMore) async {
    groupSource = chatLoadMore;
    print("source eng ${groupSource.length}");
    chatGroupId = id;
    print("id -> $chatOpenId");
    try {
      await pusher.subscribe(
          channelName: 'private-group-chat' + '.$chatGroupId');
      await pusher.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  @override
  void onInit() {
    onConnectPressed();
    super.onInit();
  }
}
