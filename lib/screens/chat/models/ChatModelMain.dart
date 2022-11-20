// To parse this JSON data, do
//
//     final chatModelMain = chatModelMainFromJson(jsonString);

import 'dart:convert';

import 'package:infixedu/screens/chat/models/ChatGroup.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';

ChatModelMain chatModelMainFromJson(String str) =>
    ChatModelMain.fromJson(json.decode(str));

String chatModelMainToJson(ChatModelMain data) => json.encode(data.toJson());

class ChatModelMain {
  ChatModelMain({
    this.users,
    this.groups,
  });

  List<ChatUser> users;
  List<ChatGroup> groups;

  factory ChatModelMain.fromJson(Map<String, dynamic> json) => ChatModelMain(
        users: json["users"] == null
            ? null
            : List<ChatUser>.from(
                json["users"].map((x) => ChatUser.fromJson(x))),
        groups: json["groups"] == null
            ? null
            : List<ChatGroup>.from(
                json["groups"].map((x) => ChatGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
      };
}
