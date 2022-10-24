// To parse this JSON data, do
//
//     final chatMessageCheckModel = chatMessageCheckModelFromJson(jsonString);

import 'dart:convert';

import 'package:infixedu/screens/chat/models/ChatMessage.dart';

ChatMessageCheckModel chatMessageCheckModelFromJson(String str) => ChatMessageCheckModel.fromJson(json.decode(str));

String chatMessageCheckModelToJson(ChatMessageCheckModel data) => json.encode(data.toJson());

class ChatMessageCheckModel {
    ChatMessageCheckModel({
        this.invalid,
        this.messages,
    });

    bool invalid;
    List<ChatMessage> messages;

    factory ChatMessageCheckModel.fromJson(Map<String, dynamic> json) => ChatMessageCheckModel(
        invalid: json["invalid"],
        messages: List<ChatMessage>.from(json["messages"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "invalid": invalid,
        "messages": List<dynamic>.from(messages.map((x) => x)),
    };
}
