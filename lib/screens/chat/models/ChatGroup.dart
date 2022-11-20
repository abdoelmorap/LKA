import 'package:infixedu/screens/chat/models/GroupThread.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';

class ChatGroup {
  ChatGroup({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.privacy,
    this.readOnly,
    this.groupType,
    this.createdBy,
    this.threads,
    this.users,
  });

  String id;
  String name;
  dynamic description;
  String photoUrl;
  dynamic privacy;
  dynamic readOnly;
  dynamic groupType;
  dynamic createdBy;
  List<GroupThread> threads;
  List<ChatUser> users;

  factory ChatGroup.fromJson(Map<String, dynamic> json) => ChatGroup(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photo_url"] == null ? null : json["photo_url"],
        privacy: json["privacy"],
        readOnly: json["read_only"],
        groupType: json["group_type"],
        createdBy: json["created_by"],
        threads: json["threads"] == null
            ? null
            : List<GroupThread>.from(
                json["threads"].map((x) => GroupThread.fromJson(x))),
        users: json["users"] == null
            ? null
            : List<ChatUser>.from(
                json["users"].map((x) => ChatUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photo_url": photoUrl == null ? null : photoUrl,
        "privacy": privacy,
        "read_only": readOnly,
        "group_type": groupType,
        "created_by": createdBy,
        "threads": threads == null
            ? null
            : List<dynamic>.from(threads.map((x) => x.toJson())),
        "users": users == null
            ? null
            : List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
