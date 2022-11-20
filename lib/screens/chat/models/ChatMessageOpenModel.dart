import 'dart:convert';

import 'package:infixedu/screens/chat/models/ChatMessage.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';

ChatMessageOpenModel chatMessageOpenModelFromJson(String str) =>
    ChatMessageOpenModel.fromJson(json.decode(str));

String chatMessageOpenModelToJson(ChatMessageOpenModel data) =>
    json.encode(data.toJson());

class ChatMessageOpenModel {
  ChatMessageOpenModel({
    this.activeUser,
    this.messages,
  });

  dynamic messages;
  ChatUser activeUser;

  factory ChatMessageOpenModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageOpenModel(
        activeUser: json["activeUser"] == null
            ? null
            : ChatUser.fromJson(json["activeUser"]),
        messages: json["messages"] is List
            ? List<ChatMessage>.from(
                json["messages"].map((x) => ChatMessage.fromJson(x)))
            : Map.from(json["messages"]).map((k, v) =>
                MapEntry<String, ChatMessage>(k, ChatMessage.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "activeUser": activeUser.toJson(),
        "messages": Map.from(messages)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class ChatLoadMoreModel {
  ChatLoadMoreModel({
    this.messages,
  });

  dynamic messages;

  factory ChatLoadMoreModel.fromJson(Map<String, dynamic> json) =>
      ChatLoadMoreModel(
        messages: json["conversations"] is List
            ? List<ChatMessage>.from(
                json["conversations"].map((x) => ChatMessage.fromJson(x)))
            : json["conversations"] == null
                ? null
                : Map.from(json["conversations"]).map((k, v) =>
                    MapEntry<String, ChatMessage>(k, ChatMessage.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "conversations": messages == null
            ? null
            : Map.from(messages)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
