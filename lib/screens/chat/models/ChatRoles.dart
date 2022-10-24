class ChatRoles {
    ChatRoles({
        this.id,
        this.name,
        this.type,
        this.activeStatus,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.schoolId,
        this.isSaas,
    });

    dynamic id;
    String name;
    String type;
    dynamic activeStatus;
    String createdBy;
    String updatedBy;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic schoolId;
    dynamic isSaas;

    factory ChatRoles.fromJson(Map<String, dynamic> json) => ChatRoles(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        activeStatus: json["active_status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        schoolId: json["school_id"],
        isSaas: json["is_saas"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "active_status": activeStatus,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "school_id": schoolId,
        "is_saas": isSaas,
    };
}