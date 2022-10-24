// To parse this JSON data, do
//
//     final feesBankPayment = feesBankPaymentFromJson(jsonString);

import 'dart:convert';

FeeWaiverReportModel feesWaiverReportModelFromJson(String str) =>
    FeeWaiverReportModel.fromJson(json.decode(str));

String feesWaiverReportModelToJson(FeeWaiverReportModel data) =>
    json.encode(data.toJson());

class FeeWaiverReportModel {
  FeeWaiverReportModel({
    this.waiverReport,
    this.totalWaiver,
  });

  Map<String, WaiverReport> waiverReport;
  int totalWaiver;

  factory FeeWaiverReportModel.fromJson(Map<String, dynamic> json) =>
      FeeWaiverReportModel(
        waiverReport: Map.from(json["waiverReport"]).map((k, v) =>
            MapEntry<String, WaiverReport>(k, WaiverReport.fromJson(v))),
        totalWaiver: json["totalWaiver"],
      );

  Map<String, dynamic> toJson() => {
        "waiverReport": Map.from(waiverReport)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "totalWaiver": totalWaiver,
      };
}

class WaiverReport {
  WaiverReport({
    this.admissionNo,
    this.rollNo,
    this.name,
    this.dueDate,
    this.waiver,
  });

  String admissionNo;
  String rollNo;
  String name;
  String dueDate;
  double waiver;

  factory WaiverReport.fromJson(Map<String, dynamic> json) => WaiverReport(
        admissionNo: json["admission_no"].toString(),
        rollNo: json["roll_no"].toString(),
        name: json["name"].toString(),
        dueDate: json["due_date"].toString(),
        waiver: json["waiver"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "admission_no": admissionNo,
        "roll_no": rollNo,
        "name": name,
        "due_date": dueDate,
        "waiver": waiver,
      };
}
