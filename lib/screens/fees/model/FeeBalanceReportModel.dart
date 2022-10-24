// To parse this JSON data, do
//
//     final feesBalanceReportModel = feesBalanceReportModelFromJson(jsonString);

import 'dart:convert';

FeesBalanceReportModel feesBalanceReportModelFromJson(String str) => FeesBalanceReportModel.fromJson(json.decode(str));

String feesBalanceReportModelToJson(FeesBalanceReportModel data) => json.encode(data.toJson());

class FeesBalanceReportModel {
    FeesBalanceReportModel({
        this.balanceReport,
        this.totalBalance,
    });

    List<BalanceReport> balanceReport;
    int totalBalance;

    factory FeesBalanceReportModel.fromJson(Map<String, dynamic> json) => FeesBalanceReportModel(
        balanceReport: List<BalanceReport>.from(json["balanceReport"].map((x) => x == null ? null : BalanceReport.fromJson(x))),
        totalBalance: json["totalBalance"],
    );

    Map<String, dynamic> toJson() => {
        "balanceReport": List<dynamic>.from(balanceReport.map((x) => x == null ? null : x.toJson())),
        "totalBalance": totalBalance,
    };
}

class BalanceReport {
    BalanceReport({
        this.admissionNo,
        this.rollNo,
        this.name,
        this.dueDate,
        this.balance,
    });

    String admissionNo;
    String rollNo;
    String name;
    String dueDate;
    double balance;

    factory BalanceReport.fromJson(Map<String, dynamic> json) => BalanceReport(
        admissionNo: json["admission_no"].toString(),
        rollNo: json["roll_no"].toString(),
        name: json["name"].toString(),
        dueDate: json["due_date"].toString(),
        balance: json["balance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "admission_no": admissionNo,
        "roll_no": rollNo,
        "name": name,
        "due_date": dueDate,
        "balance": balance,
    };
}