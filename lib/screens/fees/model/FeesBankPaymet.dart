// To parse this JSON data, do
//
//     final bankPayments = bankPaymentsFromJson(jsonString);

import 'dart:convert';

FeeBankPaymentModel bankPaymentsFromJson(String str) =>
    FeeBankPaymentModel.fromJson(json.decode(str));

String bankPaymentsToJson(FeeBankPaymentModel data) =>
    json.encode(data.toJson());

class FeeBankPaymentModel {
  FeeBankPaymentModel({
    this.feesPayments,
  });

  List<FeesPayment> feesPayments;

  factory FeeBankPaymentModel.fromJson(Map<String, dynamic> json) =>
      FeeBankPaymentModel(
        feesPayments: List<FeesPayment>.from(
            json["feesPayments"].map((x) => FeesPayment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feesPayments": List<dynamic>.from(feesPayments.map((x) => x.toJson())),
      };
}

class FeesPayment {
  FeesPayment({
    this.id,
    this.invoiceNumber,
    this.studentId,
    this.userId,
    this.paymentMethod,
    this.bankId,
    this.addWalletMoney,
    this.paymentNote,
    this.file,
    this.paidStatus,
    this.feesInvoiceId,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
    this.recordId,
    this.feeStudentInfo,
    this.transcationDetails,
  });

  int id;
  dynamic invoiceNumber;
  int studentId;
  int userId;
  String paymentMethod;
  dynamic bankId;
  int addWalletMoney;
  String paymentNote;
  String file;
  String paidStatus;
  int feesInvoiceId;
  int schoolId;
  int academicId;
  DateTime createdAt;
  DateTime updatedAt;
  int recordId;
  FeeStudentInfo feeStudentInfo;
  List<TranscationDetail> transcationDetails;

  factory FeesPayment.fromJson(Map<String, dynamic> json) => FeesPayment(
        id: json["id"] ?? "",
        invoiceNumber: json["invoice_number"] ?? "",
        studentId: json["student_id"],
        userId: json["user_id"],
        paymentMethod: json["payment_method"],
        bankId: json["bank_id"],
        addWalletMoney: json["add_wallet_money"],
        paymentNote: json["payment_note"],
        file: json["file"],
        paidStatus: json["paid_status"],
        feesInvoiceId: json["fees_invoice_id"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        recordId: json["record_id"],
        feeStudentInfo: json["fee_student_info"] == null
            ? null
            : FeeStudentInfo.fromJson(json["fee_student_info"]),
        transcationDetails: json["transcation_details"] == null
            ? null
            : List<TranscationDetail>.from(json["transcation_details"]
                .map((x) => TranscationDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "student_id": studentId,
        "user_id": userId,
        "payment_method": paymentMethod,
        "bank_id": bankId,
        "add_wallet_money": addWalletMoney,
        "payment_note": paymentNote,
        "file": file,
        "paid_status": paidStatus,
        "fees_invoice_id": feesInvoiceId,
        "school_id": schoolId,
        "academic_id": academicId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "record_id": recordId,
        "fee_student_info": feeStudentInfo.toJson(),
        "transcation_details":
            List<dynamic>.from(transcationDetails.map((x) => x.toJson())),
      };
}

class FeeStudentInfo {
  FeeStudentInfo({
    this.id,
    this.fullName,
  });

  int id;
  String fullName;

  factory FeeStudentInfo.fromJson(Map<String, dynamic> json) => FeeStudentInfo(
        id: json["id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
      };
}

class TranscationDetail {
  TranscationDetail({
    this.paidAmount,
  });

  double paidAmount;

  factory TranscationDetail.fromJson(Map<String, dynamic> json) =>
      TranscationDetail(
        paidAmount: json["paid_amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "paid_amount": paidAmount,
      };
}

class TranscationFeesType {
  TranscationFeesType({
    this.id,
    this.name,
    this.description,
    this.feesGroupId,
    this.type,
    this.courseId,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String description;
  dynamic feesGroupId;
  String type;
  dynamic courseId;
  int createdBy;
  int updatedBy;
  int schoolId;
  int academicId;
  DateTime createdAt;
  DateTime updatedAt;

  factory TranscationFeesType.fromJson(Map<String, dynamic> json) =>
      TranscationFeesType(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        feesGroupId: json["fees_group_id"],
        type: json["type"],
        courseId: json["course_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "fees_group_id": feesGroupId,
        "type": type,
        "course_id": courseId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
        "academic_id": academicId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
