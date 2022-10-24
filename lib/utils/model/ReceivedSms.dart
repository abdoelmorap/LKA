// To parse this JSON data, do
//
//     final receivedSms = receivedSmsFromJson(jsonString);

// Dart imports:
import 'dart:convert';

ReceivedSms receivedSmsFromJson(String str) => ReceivedSms.fromJson(json.decode(str));

String receivedSmsToJson(ReceivedSms data) => json.encode(data.toJson());

class ReceivedSms {
  ReceivedSms({
    this.phoneNumber,
    this.title,
    this.body,
    this.deviceId,
  });

  String phoneNumber;
  String title;
  String body;
  String deviceId;

  factory ReceivedSms.fromJson(Map<String, dynamic> json) => ReceivedSms(
    phoneNumber: json["phone_number"],
    title: json["title"],
    body: json["body"],
    deviceId: json["deviceID"],
  );

  Map<String, dynamic> toJson() => {
    "phone_number": phoneNumber,
    "title": title,
    "body": body,
    "deviceID": deviceId,
  };
}
