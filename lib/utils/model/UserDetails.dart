class UserDetails {
  UserDetails({
    this.id,
    this.admissionNo,
    this.rollNo,
    this.firstName,
    this.lastName,
    this.fullName,
    this.dateOfBirth,
    this.caste,
    this.email,
    this.mobile,
    this.admissionDate,
    this.studentPhoto,
    this.age,
    this.height,
    this.weight,
    this.currentAddress,
    this.permanentAddress,
    this.driverId,
    this.nationalIdNo,
    this.localIdNo,
    this.bankAccountNo,
    this.bankName,
    this.previousSchoolDetails,
    this.aditionalNotes,
    this.ifscCode,
    this.documentTitle1,
    this.documentFile1,
    this.documentTitle2,
    this.documentFile2,
    this.documentTitle3,
    this.documentFile3,
    this.documentTitle4,
    this.documentFile4,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.bloodgroupId,
    this.religionId,
    this.routeListId,
    this.dormitoryId,
    this.vechileId,
    this.roomId,
    this.studentCategoryId,
    this.studentGroupId,
    this.classId,
    this.sectionId,
    this.sessionId,
    this.parentId,
    this.userId,
    this.roleId,
    this.genderId,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.fathersName,
    this.fathersMobile,
    this.fathersOccupation,
    this.fathersPhoto,
    this.mothersName,
    this.mothersMobile,
    this.mothersOccupation,
    this.mothersPhoto,
    this.relation,
    this.guardiansName,
    this.guardiansMobile,
    this.guardiansEmail,
    this.guardiansOccupation,
    this.guardiansRelation,
    this.guardiansPhoto,
    this.guardiansAddress,
    this.isGuardian,
    this.className,
    this.sectionName,
  });

  dynamic id;
  dynamic admissionNo;
  dynamic rollNo;
  String firstName;
  String lastName;
  String fullName;
  DateTime dateOfBirth;
  String caste;
  String email;
  String mobile;
  DateTime admissionDate;
  String studentPhoto;
  dynamic age;
  String height;
  String weight;
  String currentAddress;
  String permanentAddress;
  String driverId;
  String nationalIdNo;
  String localIdNo;
  String bankAccountNo;
  String bankName;
  String previousSchoolDetails;
  String aditionalNotes;
  String ifscCode;
  String documentTitle1;
  dynamic documentFile1;
  String documentTitle2;
  dynamic documentFile2;
  String documentTitle3;
  dynamic documentFile3;
  String documentTitle4;
  dynamic documentFile4;
  dynamic activeStatus;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic bloodgroupId;
  dynamic religionId;
  dynamic routeListId;
  dynamic dormitoryId;
  dynamic vechileId;
  dynamic roomId;
  dynamic studentCategoryId;
  dynamic studentGroupId;
  dynamic classId;
  dynamic sectionId;
  dynamic sessionId;
  dynamic parentId;
  dynamic userId;
  dynamic roleId;
  dynamic genderId;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic schoolId;
  dynamic academicId;
  String fathersName;
  String fathersMobile;
  String fathersOccupation;
  String fathersPhoto;
  String mothersName;
  String mothersMobile;
  String mothersOccupation;
  String mothersPhoto;
  dynamic relation;
  String guardiansName;
  String guardiansMobile;
  String guardiansEmail;
  String guardiansOccupation;
  String guardiansRelation;
  String guardiansPhoto;
  String guardiansAddress;
  dynamic isGuardian;
  String className;
  String sectionName;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["id"],
    admissionNo: json["admission_no"],
    rollNo: json["roll_no"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    fullName: json["full_name"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    caste: json["caste"],
    email: json["email"],
    mobile: json["mobile"],
    admissionDate: DateTime.parse(json["admission_date"]),
    studentPhoto: json["student_photo"],
    age: json["age"],
    height: json["height"],
    weight: json["weight"],
    currentAddress: json["current_address"],
    permanentAddress: json["permanent_address"],
    driverId: json["driver_id"],
    nationalIdNo: json["national_id_no"],
    localIdNo: json["local_id_no"],
    bankAccountNo: json["bank_account_no"],
    bankName: json["bank_name"],
    previousSchoolDetails: json["previous_school_details"],
    aditionalNotes: json["aditional_notes"],
    ifscCode: json["ifsc_code"],
    documentTitle1: json["document_title_1"],
    documentFile1: json["document_file_1"],
    documentTitle2: json["document_title_2"],
    documentFile2: json["document_file_2"],
    documentTitle3: json["document_title_3"],
    documentFile3: json["document_file_3"],
    documentTitle4: json["document_title_4"],
    documentFile4: json["document_file_4"],
    activeStatus: json["active_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    bloodgroupId: json["bloodgroup_id"],
    religionId: json["religion_id"],
    routeListId: json["route_list_id"],
    dormitoryId: json["dormitory_id"],
    vechileId: json["vechile_id"],
    roomId: json["room_id"],
    studentCategoryId: json["student_category_id"],
    studentGroupId: json["student_group_id"],
    classId: json["class_id"],
    sectionId: json["section_id"],
    sessionId: json["session_id"],
    parentId: json["parent_id"],
    userId: json["user_id"],
    roleId: json["role_id"],
    genderId: json["gender_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    schoolId: json["school_id"],
    academicId: json["academic_id"],
    fathersName: json["fathers_name"],
    fathersMobile: json["fathers_mobile"],
    fathersOccupation: json["fathers_occupation"],
    fathersPhoto: json["fathers_photo"],
    mothersName: json["mothers_name"],
    mothersMobile: json["mothers_mobile"],
    mothersOccupation: json["mothers_occupation"],
    mothersPhoto: json["mothers_photo"],
    relation: json["relation"],
    guardiansName: json["guardians_name"],
    guardiansMobile: json["guardians_mobile"],
    guardiansEmail: json["guardians_email"],
    guardiansOccupation: json["guardians_occupation"],
    guardiansRelation: json["guardians_relation"],
    guardiansPhoto: json["guardians_photo"],
    guardiansAddress: json["guardians_address"],
    isGuardian: json["is_guardian"],
    className: json["class_name"],
    sectionName: json["section_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "admission_no": admissionNo,
    "roll_no": rollNo,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "caste": caste,
    "email": email,
    "mobile": mobile,
    "admission_date": "${admissionDate.year.toString().padLeft(4, '0')}-${admissionDate.month.toString().padLeft(2, '0')}-${admissionDate.day.toString().padLeft(2, '0')}",
    "student_photo": studentPhoto,
    "age": age,
    "height": height,
    "weight": weight,
    "current_address": currentAddress,
    "permanent_address": permanentAddress,
    "driver_id": driverId,
    "national_id_no": nationalIdNo,
    "local_id_no": localIdNo,
    "bank_account_no": bankAccountNo,
    "bank_name": bankName,
    "previous_school_details": previousSchoolDetails,
    "aditional_notes": aditionalNotes,
    "ifsc_code": ifscCode,
    "document_title_1": documentTitle1,
    "document_file_1": documentFile1,
    "document_title_2": documentTitle2,
    "document_file_2": documentFile2,
    "document_title_3": documentTitle3,
    "document_file_3": documentFile3,
    "document_title_4": documentTitle4,
    "document_file_4": documentFile4,
    "active_status": activeStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "bloodgroup_id": bloodgroupId,
    "religion_id": religionId,
    "route_list_id": routeListId,
    "dormitory_id": dormitoryId,
    "vechile_id": vechileId,
    "room_id": roomId,
    "student_category_id": studentCategoryId,
    "student_group_id": studentGroupId,
    "class_id": classId,
    "section_id": sectionId,
    "session_id": sessionId,
    "parent_id": parentId,
    "user_id": userId,
    "role_id": roleId,
    "gender_id": genderId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "school_id": schoolId,
    "academic_id": academicId,
    "fathers_name": fathersName,
    "fathers_mobile": fathersMobile,
    "fathers_occupation": fathersOccupation,
    "fathers_photo": fathersPhoto,
    "mothers_name": mothersName,
    "mothers_mobile": mothersMobile,
    "mothers_occupation": mothersOccupation,
    "mothers_photo": mothersPhoto,
    "relation": relation,
    "guardians_name": guardiansName,
    "guardians_mobile": guardiansMobile,
    "guardians_email": guardiansEmail,
    "guardians_occupation": guardiansOccupation,
    "guardians_relation": guardiansRelation,
    "guardians_photo": guardiansPhoto,
    "guardians_address": guardiansAddress,
    "is_guardian": isGuardian,
    "class_name": className,
    "section_name": sectionName,
  };
}
