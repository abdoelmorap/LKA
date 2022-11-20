class ChatActiveStatus {
  ChatActiveStatus({
    this.id,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic userId;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;

  factory ChatActiveStatus.fromJson(Map<String, dynamic> json) =>
      ChatActiveStatus(
        id: json["id"],
        userId: json["user_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ChatStatus {
  int status;
  String title;
  ChatStatus({this.status, this.title});
}
