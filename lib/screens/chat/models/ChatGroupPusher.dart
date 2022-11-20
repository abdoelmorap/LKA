import 'package:infixedu/screens/chat/models/ChatGroup.dart';
import 'package:infixedu/screens/chat/models/ChatMessage.dart';
import 'package:infixedu/screens/chat/models/ChatUser.dart';
import 'package:infixedu/screens/chat/models/GroupThread.dart';

class ChatGroupPusher {
    ChatGroupPusher({
        this.group,
        this.thread,
        this.conversation,
        this.user,
    });

    ChatGroup group;
    GroupThread thread;
    ChatMessage conversation;
    ChatUser user;

    factory ChatGroupPusher.fromJson(Map<String, dynamic> json) => ChatGroupPusher(
        group: ChatGroup.fromJson(json["group"]),
        thread: GroupThread.fromJson(json["thread"]),
        conversation: ChatMessage.fromJson(json["conversation"]),
        user: ChatUser.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "group": group.toJson(),
        "thread": thread.toJson(),
        "conversation": conversation.toJson(),
        "user": user.toJson(),
    };
}