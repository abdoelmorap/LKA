// To parse this JSON data, do
//
//     final systemSettings = systemSettingsFromJson(jsonString);

import 'dart:convert';

SystemSettings systemSettingsFromJson(String str) =>
    SystemSettings.fromJson(json.decode(str));

String systemSettingsToJson(SystemSettings data) => json.encode(data.toJson());

class SystemSettings {
  SystemSettings({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  SystemData data;
  dynamic message;

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        success: json["success"],
        data: SystemData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class SystemData {
  SystemData({
    this.id,
    this.schoolName,
    this.siteTitle,
    this.schoolCode,
    this.address,
    this.phone,
    this.email,
    this.fileSize,
    this.currency,
    this.currencySymbol,
    this.logo,
    this.favicon,
    this.systemVersion,
    this.currencyCode,
    this.copyrightText,
    this.schoolId,
    this.lesson,
    this.chat,
    this.feesCollection,
    this.razorPay,
    this.saas,
    this.zoom,
    this.bbb,
    this.videoWatch,
    this.jitsi,
    this.onlineExam,
    this.xenditPayment,
    this.wallet,
    this.university,
    this.feesStatus,
    this.khaltiPayment,
    this.appSlider,
    this.raudhahpay,
    this.preloaderImage,
    this.fees,
  });

  dynamic id;
  String schoolName;
  String siteTitle;
  String schoolCode;
  String address;
  String phone;
  String email;
  String fileSize;
  String currency;
  String currencySymbol;
  String logo;
  String favicon;
  String systemVersion;
  String currencyCode;
  String copyrightText;
  dynamic schoolId;
  bool lesson;
  bool chat;
  dynamic feesCollection;
  bool razorPay;
  bool saas;
  bool zoom;
  bool bbb;
  dynamic videoWatch;
  bool jitsi;
  bool onlineExam;
  bool xenditPayment;
  bool wallet;
  dynamic university;
  dynamic feesStatus;
  bool khaltiPayment;
  bool appSlider;
  bool raudhahpay;
  dynamic preloaderStatus;
  String preloaderImage;
  bool fees;

  factory SystemData.fromJson(Map<String, dynamic> json) => SystemData(
        id: json["id"],
        schoolName: json["school_name"],
        siteTitle: json["site_title"],
        schoolCode: json["school_code"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        fileSize: json["file_size"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        logo: json["logo"],
        favicon: json["favicon"],
        systemVersion: json["system_version"],
        currencyCode: json["currency_code"],
        copyrightText: json["copyright_text"],
        schoolId: json["school_id"],
        lesson: json["Lesson"],
        chat: json["Chat"],
        feesCollection: json["FeesCollection"],
        razorPay: json["RazorPay"],
        saas: json["Saas"],
        zoom: json["Zoom"],
        bbb: json["BBB"],
        videoWatch: json["VideoWatch"],
        jitsi: json["Jitsi"],
        onlineExam: json["OnlineExam"],
        xenditPayment: json["XenditPayment"],
        wallet: json["Wallet"],
        university: json["University"],
        feesStatus: json["fees_status"],
        khaltiPayment: json["KhaltiPayment"],
        appSlider: json["AppSlider"],
        raudhahpay: json["Raudhahpay"],
        preloaderImage: json["preloader_image"],
        fees: json["Fees"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school_name": schoolName,
        "site_title": siteTitle,
        "school_code": schoolCode,
        "address": address,
        "phone": phone,
        "email": email,
        "file_size": fileSize,
        "currency": currency,
        "currency_symbol": currencySymbol,
        "logo": logo,
        "favicon": favicon,
        "system_version": systemVersion,
        "currency_code": currencyCode,
        "copyright_text": copyrightText,
        "school_id": schoolId,
        "Lesson": lesson,
        "Chat": chat,
        "FeesCollection": feesCollection,
        "RazorPay": razorPay,
        "Saas": saas,
        "Zoom": zoom,
        "BBB": bbb,
        "VideoWatch": videoWatch,
        "Jitsi": jitsi,
        "OnlineExam": onlineExam,
        "XenditPayment": xenditPayment,
        "Wallet": wallet,
        "University": university,
        "fees_status": feesStatus,
        "KhaltiPayment": khaltiPayment,
        "AppSlider": appSlider,
        "Raudhahpay": raudhahpay,
        "preloader_image": preloaderImage,
        "Fees": fees,
      };
}
