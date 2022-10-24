class FeeType {
  int id;
  String name;
  dynamic description;
  int createdBy;
  int updatedBy;
  int schoolId;
  int academicId;
  DateTime createdAt;
  DateTime updatedAt;
  int feesGroupId;
  String type;
  dynamic courseId;

  FeeType({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
    this.feesGroupId,
    this.type,
    this.courseId,
  });

  factory FeeType.fromJson(Map<String, dynamic> json) {
    return FeeType(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      schoolId: json["school_id"],
      academicId: json["academic_id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      feesGroupId: json["fees_group_id"] == null ? null : json["fees_group_id"],
      type: json["type"] == null ? null : json["type"],
      courseId: json["course_id"] == null ? null : json["course_id"],
    );
  }
}

class FeeTypeList {
  List<FeeType> feeTypes;

  FeeTypeList(this.feeTypes);

  factory FeeTypeList.fromJson(List<dynamic> json) {
    List<FeeType> feeTypeList = [];

    feeTypeList = json.map((i) => FeeType.fromJson(i)).toList();

    return FeeTypeList(feeTypeList);
  }
}
