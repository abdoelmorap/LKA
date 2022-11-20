// To parse this JSON data, do
//
//     final studentDetails = studentDetailsFromJson(jsonString);

import 'dart:convert';

StudentDetailsModel studentDetailsFromJson(String str) =>
    StudentDetailsModel.fromJson(json.decode(str));

String studentDetailsToJson(StudentDetailsModel data) =>
    json.encode(data.toJson());

class StudentDetailsModel {
  StudentDetailsModel({
    this.success,
    this.studentData,
    this.message,
  });

  bool success;
  StudentData studentData;
  dynamic message;

  factory StudentDetailsModel.fromJson(Map<String, dynamic> json) =>
      StudentDetailsModel(
        success: json["success"],
        studentData: StudentData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": studentData.toJson(),
        "message": message,
      };
}

class StudentData {
  StudentData({
    this.user,
    this.userDetails,
    this.religion,
    this.bloodGroup,
    this.transport,
  });

  User user;
  UserDetails userDetails;
  BloodGroup religion;
  BloodGroup bloodGroup;
  Transport transport;

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
        user: User.fromJson(json["user"]),
        userDetails: UserDetails.fromJson(json["userDetails"]),
        religion: json["religion"] == null
            ? null
            : BloodGroup.fromJson(json["religion"]),
        bloodGroup: json["blood_group"] == null
            ? null
            : BloodGroup.fromJson(json["blood_group"]),
        transport: json["transport"] == null
            ? null
            : Transport.fromJson(json["transport"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "userDetails": userDetails.toJson(),
        "religion": religion.toJson(),
        "blood_group": bloodGroup.toJson(),
        "transport": transport.toJson(),
      };
}

class Transport {
  Transport({
    this.vehicleNo,
    this.vehicleModel,
    this.driverName,
    this.note,
  });

  String vehicleNo;
  String vehicleModel;
  String driverName;
  dynamic note;

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
        vehicleNo: json["vehicle_no"],
        vehicleModel: json["vehicle_model"],
        driverName: json["driver_name"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle_no": vehicleNo,
        "vehicle_model": vehicleModel,
        "driver_name": driverName,
        "note": note,
      };
}

class BloodGroup {
  BloodGroup({
    this.name,
  });

  String name;

  factory BloodGroup.fromJson(Map<String, dynamic> json) => BloodGroup(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class User {
  User({
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
    this.customField,
    this.customFieldFormName,
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
    this.schoolId,
    this.academicId,
    this.parents,
    this.studentRecords,
  });

  int id;
  int admissionNo;
  int rollNo;
  String firstName;
  String lastName;
  String fullName;
  String dateOfBirth;
  dynamic caste;
  String email;
  String mobile;
  DateTime admissionDate;
  String studentPhoto;
  int age;
  dynamic height;
  dynamic weight;
  String currentAddress;
  String permanentAddress;
  dynamic driverId;
  dynamic nationalIdNo;
  dynamic localIdNo;
  dynamic bankAccountNo;
  dynamic bankName;
  dynamic previousSchoolDetails;
  dynamic aditionalNotes;
  dynamic ifscCode;
  dynamic documentTitle1;
  String documentFile1;
  dynamic documentTitle2;
  String documentFile2;
  dynamic documentTitle3;
  String documentFile3;
  dynamic documentTitle4;
  String documentFile4;
  int activeStatus;
  dynamic customField;
  dynamic customFieldFormName;
  DateTime createdAt;
  DateTime updatedAt;
  int bloodgroupId;
  int religionId;
  dynamic routeListId;
  dynamic dormitoryId;
  dynamic vechileId;
  dynamic roomId;
  dynamic studentCategoryId;
  dynamic studentGroupId;
  dynamic classId;
  dynamic sectionId;
  dynamic sessionId;
  int parentId;
  int userId;
  int roleId;
  int genderId;
  int schoolId;
  int academicId;
  Parents parents;
  List<StudentRecord> studentRecords;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        admissionNo: json["admission_no"],
        rollNo: json["roll_no"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        dateOfBirth: json["date_of_birth"],
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
        customField: json["custom_field"],
        customFieldFormName: json["custom_field_form_name"],
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
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        parents: Parents.fromJson(json["parents"]),
        studentRecords: List<StudentRecord>.from(
            json["student_records"].map((x) => StudentRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admission_no": admissionNo,
        "roll_no": rollNo,
        "first_name": firstName,
        "last_name": lastName,
        "full_name": fullName,
        "date_of_birth": dateOfBirth,
        "caste": caste,
        "email": email,
        "mobile": mobile,
        "admission_date":
            "${admissionDate.year.toString().padLeft(4, '0')}-${admissionDate.month.toString().padLeft(2, '0')}-${admissionDate.day.toString().padLeft(2, '0')}",
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
        "custom_field": customField,
        "custom_field_form_name": customFieldFormName,
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
        "school_id": schoolId,
        "academic_id": academicId,
        "parents": parents.toJson(),
        "student_records":
            List<dynamic>.from(studentRecords.map((x) => x.toJson())),
      };
}

class Parents {
  Parents({
    this.id,
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
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.schoolId,
    this.academicId,
    this.parentUser,
  });

  int id;
  dynamic fathersName;
  dynamic fathersMobile;
  dynamic fathersOccupation;
  String fathersPhoto;
  dynamic mothersName;
  dynamic mothersMobile;
  dynamic mothersOccupation;
  String mothersPhoto;
  String relation;
  String guardiansName;
  String guardiansMobile;
  String guardiansEmail;
  String guardiansOccupation;
  String guardiansRelation;
  String guardiansPhoto;
  String guardiansAddress;
  dynamic isGuardian;
  int activeStatus;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;
  int schoolId;
  int academicId;
  ParentUser parentUser;

  factory Parents.fromJson(Map<String, dynamic> json) => Parents(
        id: json["id"],
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
        activeStatus: json["active_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        parentUser: ParentUser.fromJson(json["parent_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "active_status": activeStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_id": userId,
        "school_id": schoolId,
        "academic_id": academicId,
        "parent_user": parentUser.toJson(),
      };
}

class ParentUser {
  ParentUser({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.usertype,
    this.activeStatus,
    this.randomCode,
    this.notificationToken,
    this.createdAt,
    this.updatedAt,
    this.language,
    this.styleId,
    this.rtlLtl,
    this.selectedSession,
    this.createdBy,
    this.updatedBy,
    this.accessStatus,
    this.schoolId,
    this.roleId,
    this.isAdministrator,
    this.isRegistered,
    this.deviceToken,
    this.stripeId,
    this.cardBrand,
    this.cardLastFour,
    this.verified,
    this.trialEndsAt,
    this.walletBalance,
    this.phoneNumber,
    this.firstName,
    this.avatarUrl,
    this.blockedByMe,
  });

  int id;
  dynamic fullName;
  String username;
  String email;
  dynamic usertype;
  int activeStatus;
  dynamic randomCode;
  dynamic notificationToken;
  DateTime createdAt;
  DateTime updatedAt;
  String language;
  int styleId;
  int rtlLtl;
  int selectedSession;
  int createdBy;
  int updatedBy;
  int accessStatus;
  int schoolId;
  int roleId;
  String isAdministrator;
  int isRegistered;
  dynamic deviceToken;
  dynamic stripeId;
  dynamic cardBrand;
  dynamic cardLastFour;
  dynamic verified;
  dynamic trialEndsAt;
  int walletBalance;
  String phoneNumber;
  dynamic firstName;
  String avatarUrl;
  bool blockedByMe;

  factory ParentUser.fromJson(Map<String, dynamic> json) => ParentUser(
        id: json["id"],
        fullName: json["full_name"],
        username: json["username"],
        email: json["email"],
        usertype: json["usertype"],
        activeStatus: json["active_status"],
        randomCode: json["random_code"],
        notificationToken: json["notificationToken"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        language: json["language"],
        styleId: json["style_id"],
        rtlLtl: json["rtl_ltl"],
        selectedSession: json["selected_session"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        accessStatus: json["access_status"],
        schoolId: json["school_id"],
        roleId: json["role_id"],
        isAdministrator: json["is_administrator"],
        isRegistered: json["is_registered"],
        deviceToken: json["device_token"],
        stripeId: json["stripe_id"],
        cardBrand: json["card_brand"],
        cardLastFour: json["card_last_four"],
        verified: json["verified"],
        trialEndsAt: json["trial_ends_at"],
        walletBalance: json["wallet_balance"],
        phoneNumber: json["phone_number"],
        firstName: json["first_name"],
        avatarUrl: json["avatar_url"],
        blockedByMe: json["blocked_by_me"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "username": username,
        "email": email,
        "usertype": usertype,
        "active_status": activeStatus,
        "random_code": randomCode,
        "notificationToken": notificationToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "language": language,
        "style_id": styleId,
        "rtl_ltl": rtlLtl,
        "selected_session": selectedSession,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "access_status": accessStatus,
        "school_id": schoolId,
        "role_id": roleId,
        "is_administrator": isAdministrator,
        "is_registered": isRegistered,
        "device_token": deviceToken,
        "stripe_id": stripeId,
        "card_brand": cardBrand,
        "card_last_four": cardLastFour,
        "verified": verified,
        "trial_ends_at": trialEndsAt,
        "wallet_balance": walletBalance,
        "phone_number": phoneNumber,
        "first_name": firstName,
        "avatar_url": avatarUrl,
        "blocked_by_me": blockedByMe,
      };
}

class StudentRecord {
  StudentRecord({
    this.id,
    this.classId,
    this.sectionId,
    this.rollNo,
    this.isPromote,
    this.sessionId,
    this.schoolId,
    this.academicId,
    this.studentId,
    this.createdAt,
    this.updatedAt,
    this.isDefault,
  });

  int id;
  int classId;
  int sectionId;
  String rollNo;
  int isPromote;
  int sessionId;
  int schoolId;
  int academicId;
  int studentId;
  DateTime createdAt;
  DateTime updatedAt;
  int isDefault;

  factory StudentRecord.fromJson(Map<String, dynamic> json) => StudentRecord(
        id: json["id"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        rollNo: json["roll_no"] == null ? null : json["roll_no"],
        isPromote: json["is_promote"],
        sessionId: json["session_id"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        studentId: json["student_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class_id": classId,
        "section_id": sectionId,
        "roll_no": rollNo == null ? null : rollNo,
        "is_promote": isPromote,
        "session_id": sessionId,
        "school_id": schoolId,
        "academic_id": academicId,
        "student_id": studentId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_default": isDefault,
      };
}

class UserDetails {
  UserDetails({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.admissionNo,
    this.classSection,
    this.fatherName,
    this.fathersMobile,
    this.motherName,
    this.guardiansName,
    this.guardiansMobile,
    this.guardiansEmail,
    this.mothersMobile,
  });

  int id;
  int userId;
  String fullName;
  dynamic phoneNumber;
  int admissionNo;
  List<String> classSection;
  dynamic fatherName;
  dynamic fathersMobile;
  dynamic motherName;
  String guardiansName;
  String guardiansMobile;
  String guardiansEmail;
  dynamic mothersMobile;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        userId: json["user_id"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        admissionNo: json["admission_no"],
        classSection: List<String>.from(json["class_section"].map((x) => x)),
        fatherName: json["father_name"],
        fathersMobile: json["fathers_mobile"],
        motherName: json["mother_name"],
        guardiansName: json["guardians_name"],
        guardiansMobile: json["guardians_mobile"],
        guardiansEmail: json["guardians_email"],
        mothersMobile: json["mothers_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "admission_no": admissionNo,
        "class_section": List<dynamic>.from(classSection.map((x) => x)),
        "father_name": fatherName,
        "fathers_mobile": fathersMobile,
        "mother_name": motherName,
        "guardians_name": guardiansName,
        "guardians_mobile": guardiansMobile,
        "guardians_email": guardiansEmail,
        "mothers_mobile": mothersMobile,
      };
}
