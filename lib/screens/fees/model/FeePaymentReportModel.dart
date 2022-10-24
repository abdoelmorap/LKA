// To parse this JSON data, do
//
//     final feesBankPayment = feesBankPaymentFromJson(jsonString);

import 'dart:convert';

FeePaymentReportModel feesPaymentReportModelFromJson(String str) => FeePaymentReportModel.fromJson(json.decode(str));

String feesPaymentReportModelToJson(FeePaymentReportModel data) => json.encode(data.toJson());

class FeePaymentReportModel {
    FeePaymentReportModel({
        this.paymentReport,
        this.totalPayment,
    });

    List<PaymentReport> paymentReport;
    int totalPayment;

    factory FeePaymentReportModel.fromJson(Map<String, dynamic> json) => FeePaymentReportModel(
        paymentReport: List<PaymentReport>.from(json["paymentReport"].map((x) => PaymentReport.fromJson(x))),
        totalPayment: json["totalPayment"] == null ? null : json["totalPayment"],
    );

    Map<String, dynamic> toJson() => {
        "paymentReport": List<dynamic>.from(paymentReport.map((x) => x.toJson())),
        "totalPayment": totalPayment,
    };
}


class PaymentReport {
    PaymentReport({
        this.admissionNo,
        this.rollNo,
        this.name,
        this.dueDate,
        this.paid,
    });

    String admissionNo;
    String rollNo;
    String name;
    String dueDate;
    double paid;

    factory PaymentReport.fromJson(Map<String, dynamic> json) => PaymentReport(
        admissionNo: json["admission_no"].toString(),
        rollNo: json["roll_no"].toString(),
        name: json["name"].toString(),
        dueDate: json["due_date"].toString(),
        paid: json["paid"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "admission_no": admissionNo,
        "roll_no": rollNo,
        "name": name,
        "due_date": dueDate,
        "paid": paid,
    };
}
