import 'package:infixedu/screens/chat/models/ChatMessage.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';

class GroupThread {
  GroupThread({
    this.id,
    this.userId,
    this.conversationId,
    this.groupId,
    this.readAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.conversation,
    this.user,
  });

  dynamic id;
  dynamic userId;
  dynamic conversationId;
  String groupId;
  dynamic readAt;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  ChatMessage conversation;
  ChatUser user;

  factory GroupThread.fromJson(Map<String, dynamic> json) => GroupThread(
        id: json["id"] is String
            ? int.parse(json["id"].toString())
            : json["id"],
        userId: json["user_id"] is String
            ? int.parse(json["user_id"].toString())
            : json["user_id"],
        conversationId: json["conversation_id"] is String
            ? int.parse(json["conversation_id"].toString())
            : json["conversation_id"],
        groupId: json["group_id"],
        readAt: json["read_at"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        conversation: json["conversation"] == null
            ? null
            : ChatMessage.fromJson(json["conversation"]),
        user: json["user"] == null ? null : ChatUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "conversation_id": conversationId,
        "group_id": groupId,
        "read_at": readAt,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "conversation": conversation == null ? null : conversation.toJson(),
        "user": user == null ? null : user.toJson(),
      };
}
