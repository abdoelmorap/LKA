import 'package:infixedu/screens/chat/models/FromToUser.dart';
import 'package:infixedu/screens/chat/models/ReplyMessage.dart';

class ChatMessage {
  ChatMessage({
    this.id,
    this.fromId,
    this.toId,
    this.message,
    this.status,
    this.messageType,
    this.fileName,
    this.originalFileName,
    this.initial,
    this.reply,
    this.forward,
    this.deletedByTo,
    this.createdAt,
    this.forwardFrom,
    this.fromUser,
    this.toUser,
  });

  dynamic id;
  dynamic fromId;
  dynamic toId;
  String message;
  dynamic status;
  dynamic messageType;
  dynamic fileName;
  dynamic originalFileName;
  dynamic initial;
  dynamic reply;
  dynamic forward;
  dynamic deletedByTo;
  DateTime createdAt;
  ReplyMessage forwardFrom;
  FromToUser fromUser;
  FromToUser toUser;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        fromId: json["from_id"],
        toId: json["to_id"],
        message: json["message"] == null ? null : json["message"],
        status: json["status"],
        messageType: json["message_type"],
        fileName: json["file_name"],
        originalFileName: json["original_file_name"],
        initial: json["initial"],
        reply:
            json["reply"] == null ? null : json["reply"] is int ? json["reply"] : ReplyMessage.fromJson(json["reply"]),
        forward: json["forward"] == null ? null : json["forward"],
        deletedByTo: json["deleted_by_to"],
        createdAt: DateTime.parse(json["created_at"]),
        forwardFrom: json["forward_from"] == null
            ? null
            : ReplyMessage.fromJson(json["forward_from"]),
        fromUser: json["from_user"] == null
            ? null
            : FromToUser.fromJson(json["from_user"]),
        toUser: json["to_user"] == null
            ? null
            : FromToUser.fromJson(json["to_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_id": fromId,
        "to_id": toId,
        "message": message,
        "status": status,
        "message_type": messageType,
        "file_name": fileName,
        "original_file_name": originalFileName,
        "initial": initial,
        "reply": reply == null ? null : reply.toJson(),
        "forward": forward == null ? null : forward,
        "deleted_by_to": deletedByTo,
        "created_at": createdAt.toIso8601String(),
        "forward_from": forwardFrom == null ? null : forwardFrom.toJson(),
        "from_user": fromUser == null ? null : fromUser.toJson(),
        "to_user": toUser == null ? null : toUser.toJson(),
      };
}
