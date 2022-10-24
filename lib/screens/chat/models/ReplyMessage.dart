class ReplyMessage {
    ReplyMessage({
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
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
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
    dynamic deletedAt;
    DateTime createdAt;
    DateTime updatedAt;

    factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
        id: json["id"],
        fromId: json["from_id"],
        toId: json["to_id"],
        message: json["message"],
        status: json["status"],
        messageType: json["message_type"],
        fileName: json["file_name"],
        originalFileName: json["original_file_name"],
        initial: json["initial"],
        reply: json["reply"],
        forward: json["forward"] == null ? null : json["forward"],
        deletedByTo: json["deleted_by_to"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "reply": reply == null ? null : reply,
        "forward": forward,
        "deleted_by_to": deletedByTo,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}