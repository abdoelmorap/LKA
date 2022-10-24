class UserNotifications {
  UserNotifications({
    this.id,
    this.date,
    this.message,
    this.url,
    this.createdAt,
    this.isRead,
  });

  dynamic id;
  DateTime date;
  String message;
  String url;
  DateTime createdAt;
  dynamic isRead;

  factory UserNotifications.fromJson(Map<String, dynamic> json) => UserNotifications(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    message: json["message"],
    url: json["url"] == null ? null : json["url"],
    createdAt: DateTime.parse(json["created_at"]),
    isRead: json["is_read"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "message": message,
    "url": url == null ? null : url,
    "created_at": createdAt.toIso8601String(),
    "is_read": isRead,
  };
}

class UserNotificationList {
  List<UserNotifications> userNotifications;

  UserNotificationList({this.userNotifications});

  factory UserNotificationList.fromJson(List<dynamic> json) {
    List<UserNotifications> uploadedContent = [];

    uploadedContent = json.map((i) => UserNotifications.fromJson(i)).toList();

    return UserNotificationList(userNotifications: uploadedContent);
  }
}
