import 'dart:convert';

import 'package:infixedu/screens/chat/models/ChatGroup.dart';
import 'package:infixedu/screens/chat/models/GroupThread.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';

ChatGroupOpenModel chatGroupOpenModelFromJson(String str) =>
    ChatGroupOpenModel.fromJson(json.decode(str));

String chatGroupOpenModelToJson(ChatGroupOpenModel data) =>
    json.encode(data.toJson());

class ChatGroupOpenModel {
  ChatGroupOpenModel({
    this.group,
    this.users,
    this.myRole,
  });
  ChatGroup group;
  List<ChatUser> users;
  dynamic myRole;

  factory ChatGroupOpenModel.fromJson(Map<String, dynamic> json) =>
      ChatGroupOpenModel(
        group: ChatGroup.fromJson(json["group"]),
        users:
            List<ChatUser>.from(json["users"].map((x) => ChatUser.fromJson(x))),
        myRole: json["myRole"] == null ? null : json["myRole"],
      );

  Map<String, dynamic> toJson() => {
        "group": group.toJson(),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "myRole": myRole == null ? null : myRole,
      };
}

class ChatGroupLoadMoreModel {
  ChatGroupLoadMoreModel({
    this.success,
    this.singleThreads,
  });
  bool success;
  List<GroupThread> singleThreads;

  factory ChatGroupLoadMoreModel.fromJson(Map<String, dynamic> json) =>
      ChatGroupLoadMoreModel(
        success: json["success"],
        singleThreads: json["threads"] is! List
            ? null
            : json["threads"] == null
                ? null
                : List<GroupThread>.from(
                    json["threads"].map((x) => GroupThread.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "threads": List<dynamic>.from(singleThreads.map((x) => x.toJson())),
      };
}

ChatGroupCheckMsgModel chatGroupCheckMsgModelFromJson(String str) =>
    ChatGroupCheckMsgModel.fromJson(json.decode(str));

String chatGroupCheckMsgModelToJson(ChatGroupCheckMsgModel data) =>
    json.encode(data.toJson());

class ChatGroupCheckMsgModel {
  ChatGroupCheckMsgModel({
    this.invalid,
    this.messages,
  });

  bool invalid;
  Map<String, GroupThread> messages;

  factory ChatGroupCheckMsgModel.fromJson(Map<String, dynamic> json) =>
      ChatGroupCheckMsgModel(
        invalid: json["invalid"],
        messages: json["messages"] == null
            ? null
            : Map.from(json["messages"]).map((k, v) =>
                MapEntry<String, GroupThread>(k, GroupThread.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "invalid": invalid,
        "messages": messages == null
            ? null
            : Map.from(messages)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
