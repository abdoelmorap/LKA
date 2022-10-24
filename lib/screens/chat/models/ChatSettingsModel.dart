// To parse this JSON data, do
//
//     final chatSettingsModel = chatSettingsModelFromJson(jsonString);

import 'dart:convert';

ChatSettingsModel chatSettingsModelFromJson(String str) =>
    ChatSettingsModel.fromJson(json.decode(str));

String chatSettingsModelToJson(ChatSettingsModel data) =>
    json.encode(data.toJson());

class ChatSettingsModel {
  ChatSettingsModel({
    this.permissionSettings,
    this.invitationSettings,
    this.chatSettings,
  });

  PermissionSettings permissionSettings;
  InvitationSettings invitationSettings;
  ChatSettings chatSettings;

  factory ChatSettingsModel.fromJson(Map<String, dynamic> json) =>
      ChatSettingsModel(
        permissionSettings:
            PermissionSettings.fromJson(json["permission_settings"]),
        invitationSettings:
            InvitationSettings.fromJson(json["invitation_settings"]),
        chatSettings: ChatSettings.fromJson(json["chat_settings"]),
      );

  Map<String, dynamic> toJson() => {
        "permission_settings": permissionSettings.toJson(),
        "invitation_settings": invitationSettings.toJson(),
        "chat_settings": chatSettings.toJson(),
      };
}

class ChatSettings {
  ChatSettings({
    this.chatCanTeacherChatWithParents,
    this.chatCanStudentChatWithAdminAccount,
    this.chatAdminCanChatWithoutInvitation,
    this.chatOpen,
    this.chatMethod,
    this.pusherAppKey,
    this.pusherAppCluster,
    this.pusherAppSecret,
    this.pusherAppID,
  });

  String chatCanTeacherChatWithParents;
  String chatCanStudentChatWithAdminAccount;
  String chatAdminCanChatWithoutInvitation;
  String chatOpen;
  String chatMethod;
  String pusherAppKey;
  String pusherAppCluster;
  String pusherAppSecret;
  String pusherAppID;

  factory ChatSettings.fromJson(Map<String, dynamic> json) => ChatSettings(
        chatCanTeacherChatWithParents:
            json["chat_can_teacher_chat_with_parents"],
        chatCanStudentChatWithAdminAccount:
            json["chat_can_student_chat_with_admin_account"],
        chatAdminCanChatWithoutInvitation:
            json["chat_admin_can_chat_without_invitation"],
        chatOpen: json["chat_open"],
        chatMethod: json["method"],
        pusherAppKey: json["pusher_app_key"],
        pusherAppCluster: json["pusher_app_cluster"],
        pusherAppSecret: json["pusher_app_secret"],
        pusherAppID: json["pusher_app_id"],
      );

  Map<String, dynamic> toJson() => {
        "chat_can_teacher_chat_with_parents": chatCanTeacherChatWithParents,
        "chat_can_student_chat_with_admin_account":
            chatCanStudentChatWithAdminAccount,
        "chat_admin_can_chat_without_invitation":
            chatAdminCanChatWithoutInvitation,
        "chat_open": chatOpen,
        "method": chatMethod,
        "pusher_app_key": pusherAppKey,
        "pusher_app_cluster": pusherAppCluster,
        "pusher_app_secret": pusherAppSecret,
        "pusher_app_id": pusherAppID,
      };
}

class InvitationSettings {
  InvitationSettings({
    this.chatInvitationRequirement,
  });

  String chatInvitationRequirement;

  factory InvitationSettings.fromJson(Map<String, dynamic> json) =>
      InvitationSettings(
        chatInvitationRequirement: json["chat_invitation_requirement"],
      );

  Map<String, dynamic> toJson() => {
        "chat_invitation_requirement": chatInvitationRequirement,
      };
}

class PermissionSettings {
  PermissionSettings({
    this.chatCanUploadFile,
    this.chatFileLimit,
    this.chatCanMakeGroup,
    this.chatStaffOrTeacherCanBanStudent,
    this.chatTeacherCanPinTopMessage,
  });

  String chatCanUploadFile;
  String chatFileLimit;
  String chatCanMakeGroup;
  String chatStaffOrTeacherCanBanStudent;
  String chatTeacherCanPinTopMessage;

  factory PermissionSettings.fromJson(Map<String, dynamic> json) =>
      PermissionSettings(
        chatCanUploadFile: json["chat_can_upload_file"],
        chatFileLimit: json["chat_file_limit"],
        chatCanMakeGroup: json["chat_can_make_group"],
        chatStaffOrTeacherCanBanStudent:
            json["chat_staff_or_teacher_can_ban_student"],
        chatTeacherCanPinTopMessage: json["chat_teacher_can_pin_top_message"],
      );

  Map<String, dynamic> toJson() => {
        "chat_can_upload_file": chatCanUploadFile,
        "chat_file_limit": chatFileLimit,
        "chat_can_make_group": chatCanMakeGroup,
        "chat_staff_or_teacher_can_ban_student":
            chatStaffOrTeacherCanBanStudent,
        "chat_teacher_can_pin_top_message": chatTeacherCanPinTopMessage,
      };
}
