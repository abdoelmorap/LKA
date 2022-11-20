// To parse this JSON data, do
//
//     final aboutSchool = aboutSchoolFromJson(jsonString);

// Dart imports:
import 'dart:convert';

AboutSchool aboutSchoolFromJson(String str) => AboutSchool.fromJson(json.decode(str));

String aboutSchoolToJson(AboutSchool data) => json.encode(data.toJson());

class AboutSchool {
  AboutSchool({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  AboutData data;
  dynamic message;

  factory AboutSchool.fromJson(Map<String, dynamic> json) => AboutSchool(
    success: json["success"],
    data: AboutData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class AboutData {
  AboutData({
    this.mainDescription,
    this.schoolName,
    this.siteTitle,
    this.schoolCode,
    this.address,
    this.phone,
    this.email,
    this.logo,
    this.languageName,
    this.session,
    this.copyrightText,
  });

  String mainDescription;
  String schoolName;
  String siteTitle;
  dynamic schoolCode;
  String address;
  dynamic phone;
  String email;
  String logo;
  String languageName;
  String session;
  dynamic copyrightText;

  factory AboutData.fromJson(Map<String, dynamic> json) => AboutData(
    mainDescription: json["main_description"],
    schoolName: json["school_name"],
    siteTitle: json["site_title"],
    schoolCode: json["school_code"],
    address: json["address"],
    phone: json["phone"],
    email: json["email"],
    logo: json["logo"],
    languageName: json["language_name"],
    session: json["session"],
    copyrightText: json["copyright_text"],
  );

  Map<String, dynamic> toJson() => {
    "main_description": mainDescription,
    "school_name": schoolName,
    "site_title": siteTitle,
    "school_code": schoolCode,
    "address": address,
    "phone": phone,
    "email": email,
    "logo": logo,
    "language_name": languageName,
    "session": session,
    "copyright_text": copyrightText,
  };
}
