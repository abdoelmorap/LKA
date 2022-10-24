// To parse this JSON data, do
//
//     final feesBankPayment = feesBankPaymentFromJson(jsonString);

import 'dart:convert';

FeeFineReportModel feesBankPaymentFromJson(String str) => FeeFineReportModel.fromJson(json.decode(str));

String feesBankPaymentToJson(FeeFineReportModel data) => json.encode(data.toJson());

class FeeFineReportModel {
    FeeFineReportModel({
        this.fineReport,
        this.totalFine,
    });

    Map<String, FineReport> fineReport;
    int totalFine;

    factory FeeFineReportModel.fromJson(Map<String, dynamic> json) => FeeFineReportModel(
        fineReport: Map.from(json["fineReport"]).map((k, v) => MapEntry<String, FineReport>(k, FineReport.fromJson(v))),
        totalFine: json["totalFine"],
    );

    Map<String, dynamic> toJson() => {
        "fineReport": Map.from(fineReport).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "totalFine": totalFine,
    };
}



class FineReport {
    FineReport({
        this.admissionNo,
        this.rollNo,
        this.name,
        this.dueDate,
        this.fine,
    });

    String admissionNo;
    String rollNo;
    String name;
    String dueDate;
    double fine;

    factory FineReport.fromJson(Map<String, dynamic> json) => FineReport(
        admissionNo: json["admission_no"].toString(),
        rollNo: json["roll_no"].toString(),
        name: json["name"].toString(),
        dueDate: json["due_date"].toString(),
        fine: json["fine"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "admission_no": admissionNo,
        "roll_no": rollNo,
        "name": name,
        "due_date": dueDate,
        "fine": fine,
    };
}
