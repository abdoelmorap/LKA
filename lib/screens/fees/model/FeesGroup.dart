class FeeGroup {
  int id;
  String name;
  dynamic description;
  int createdBy;
  int updatedBy;
  int schoolId;
  int academicId;
  DateTime createdAt;
  DateTime updatedAt;

  FeeGroup({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
  });

  factory FeeGroup.fromJson(Map<String, dynamic> json) {
    return FeeGroup(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      schoolId: json["school_id"],
      academicId: json["academic_id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}

class FeeGroupList {
  List<FeeGroup> feeGroups;

  FeeGroupList(this.feeGroups);

  factory FeeGroupList.fromJson(List<dynamic> json) {
    List<FeeGroup> feeGroupsList = [];

    feeGroupsList = json.map((i) => FeeGroup.fromJson(i)).toList();

    return FeeGroupList(feeGroupsList);
  }
}
