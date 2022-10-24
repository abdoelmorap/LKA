// To parse this JSON data, do
//
//     final chatFilesModel = chatFilesModelFromJson(jsonString);

import 'dart:convert';

ChatFilesModel chatFilesModelFromJson(String str) =>
    ChatFilesModel.fromJson(json.decode(str));

String chatFilesModelToJson(ChatFilesModel data) => json.encode(data.toJson());

class ChatFilesModel {
  ChatFilesModel({
    this.messages,
  });

  dynamic messages;

  factory ChatFilesModel.fromJson(Map<String, dynamic> json) => ChatFilesModel(
        messages: json["messages"] is List
            ? List<MessageFile>.from(
                json["messages"].map((x) => MessageFile.fromJson(x)))
            : Map.from(json["messages"]).map((k, v) =>
                MapEntry<String, MessageFile>(k, MessageFile.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "messages": messages is List
            ? List<dynamic>.from(messages.map((x) => x.toJson()))
            : Map.from(messages)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class MessageFile {
  MessageFile({
    this.id,
    this.message,
    this.status,
    this.messageType,
    this.fileName,
    this.originalFileName,
    this.createdAt,
  });

  dynamic id;
  String message;
  dynamic status;
  dynamic messageType;
  String fileName;
  String originalFileName;
  DateTime createdAt;

  factory MessageFile.fromJson(Map<String, dynamic> json) => MessageFile(
        id: json["id"],
        message: json["message"] == null ? null : json["message"],
        status: json["status"],
        messageType: json["message_type"],
        fileName: json["file_name"] == null ? null : json["file_name"],
        originalFileName: json["original_file_name"] == null
            ? null
            : json["original_file_name"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message == null ? null : message,
        "status": status,
        "message_type": messageType == null ? null : messageType,
        "file_name": fileName == null ? null : fileName,
        "original_file_name":
            originalFileName == null ? null : originalFileName,
        "created_at": createdAt.toIso8601String(),
      };
}
