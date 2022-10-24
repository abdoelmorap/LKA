// To parse this JSON data, do
//
//     final feesAdminAddPaymentModel = feesAdminAddPaymentModelFromJson(jsonString);

import 'dart:convert';

FeesAdminAddPaymentModel feesAdminAddPaymentModelFromJson(String str) =>
    FeesAdminAddPaymentModel.fromJson(json.decode(str));

String feesAdminAddPaymentModelToJson(FeesAdminAddPaymentModel data) =>
    json.encode(data.toJson());

class FeesAdminAddPaymentModel {
  FeesAdminAddPaymentModel({
    this.feesTypes,
    this.paymentMethods,
    this.bankAccounts,
    this.invoiceInfo,
    this.invoiceDetails,
    this.stripeInfo,
    this.walletBalance,
  });

  List<FeesType> feesTypes;
  List<PaymentMethod> paymentMethods;
  List<BankAccount> bankAccounts;
  InvoiceInfo invoiceInfo;
  List<InvoiceDetail> invoiceDetails;
  StripeInfo stripeInfo;
  double walletBalance;

  factory FeesAdminAddPaymentModel.fromJson(Map<String, dynamic> json) =>
      FeesAdminAddPaymentModel(
        feesTypes: List<FeesType>.from(
            json["feesTypes"].map((x) => FeesType.fromJson(x))),
        paymentMethods: List<PaymentMethod>.from(
            json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
        bankAccounts: List<BankAccount>.from(
            json["bankAccounts"].map((x) => BankAccount.fromJson(x))),
        invoiceInfo: InvoiceInfo.fromJson(json["invoiceInfo"]),
        invoiceDetails: List<InvoiceDetail>.from(
            json["invoiceDetails"].map((x) => InvoiceDetail.fromJson(x))),
        stripeInfo: StripeInfo.fromJson(json["stripe_info"]),
        walletBalance: json["walletBalance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "feesTypes": List<dynamic>.from(feesTypes.map((x) => x.toJson())),
        "paymentMethods":
            List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "bankAccounts": List<dynamic>.from(bankAccounts.map((x) => x.toJson())),
        "invoiceInfo": invoiceInfo.toJson(),
        "invoiceDetails":
            List<dynamic>.from(invoiceDetails.map((x) => x.toJson())),
        "stripe_info": stripeInfo.toJson(),
        "walletBalance": walletBalance,
      };
}

class FeesType {
    FeesType({
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
    int feesGroupId;
    String type;
    dynamic courseId;
    int createdBy;
    int updatedBy;
    int schoolId;
    int academicId;
    DateTime createdAt;
    DateTime updatedAt;

    factory FeesType.fromJson(Map<String, dynamic> json) => FeesType(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        feesGroupId: json["fees_group_id"] == null ? null : json["fees_group_id"],
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
        "fees_group_id": feesGroupId == null ? null : feesGroupId,
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


class BankAccount {
  BankAccount({
    this.id,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.accountType,
    this.openingBalance,
    this.currentBalance,
    this.note,
    this.activeStatus,
    this.schoolId,
    this.academicId,
  });

  int id;
  String bankName;
  String accountName;
  String accountNumber;
  String accountType;
  int openingBalance;
  int currentBalance;
  dynamic note;
  int activeStatus;
  int schoolId;
  int academicId;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        bankName: json["bank_name"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        accountType: json["account_type"],
        openingBalance: json["opening_balance"],
        currentBalance: json["current_balance"],
        note: json["note"],
        activeStatus: json["active_status"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "account_name": accountName,
        "account_number": accountNumber,
        "account_type": accountType,
        "opening_balance": openingBalance,
        "current_balance": currentBalance,
        "note": note,
        "active_status": activeStatus,
        "school_id": schoolId,
        "academic_id": academicId,
      };
}

class InvoiceDetail {
  InvoiceDetail({
    this.id,
    this.feesInvoiceId,
    this.feesType,
    this.amount,
    this.weaver,
    this.fine,
    this.subTotal,
    this.paidAmount,
    this.dueAmount,
    this.note,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int feesInvoiceId;
  int feesType;
  double amount;
  double weaver;
  double fine;
  double subTotal;
  double paidAmount;
  double dueAmount;
  String note;
  int schoolId;
  int academicId;
  DateTime createdAt;
  DateTime updatedAt;

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        id: json["id"],
        feesInvoiceId: json["fees_invoice_id"],
        feesType: json["fees_type"],
        amount: json["amount"] == null ? 0.0 : json["amount"].toDouble(),
        weaver: json["weaver"] == null ? 0.0 : json["weaver"].toDouble(),
        fine: json["fine"] == null ? 0.0 : json["fine"].toDouble(),
        subTotal:
            json["sub_total"] == null ? 0.0 : json["sub_total"].toDouble(),
        paidAmount:
            json["paid_amount"] == null ? 0.0 : json["paid_amount"].toDouble(),
        dueAmount:
            json["due_amount"] == null ? 0.0 : json["due_amount"].toDouble(),
        note: json["note"] == null ? "" : json["note"].toString(),
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fees_invoice_id": feesInvoiceId,
        "fees_type": feesType,
        "amount": amount,
        "weaver": weaver,
        "fine": fine,
        "sub_total": subTotal,
        "paid_amount": paidAmount,
        "due_amount": dueAmount,
        "note": note,
        "school_id": schoolId,
        "academic_id": academicId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class InvoiceInfo {
  InvoiceInfo({
    this.id,
    this.invoiceId,
    this.studentId,
    this.classId,
    this.createDate,
    this.dueDate,
    this.paymentStatus,
    this.paymentMethod,
    this.bankId,
    this.type,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
    this.recordId,
  });

  int id;
  String invoiceId;
  int studentId;
  int classId;
  DateTime createDate;
  DateTime dueDate;
  String paymentStatus;
  dynamic paymentMethod;
  dynamic bankId;
  String type;
  int schoolId;
  int academicId;
  DateTime createdAt;
  DateTime updatedAt;
  int recordId;

  factory InvoiceInfo.fromJson(Map<String, dynamic> json) => InvoiceInfo(
        id: json["id"],
        invoiceId: json["invoice_id"],
        studentId: json["student_id"],
        classId: json["class_id"],
        createDate: DateTime.parse(json["create_date"]),
        dueDate: DateTime.parse(json["due_date"]),
        paymentStatus: json["payment_status"],
        paymentMethod: json["payment_method"],
        bankId: json["bank_id"],
        type: json["type"],
        schoolId: json["school_id"],
        academicId: json["academic_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        recordId: json["record_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "student_id": studentId,
        "class_id": classId,
        "create_date":
            "${createDate.year.toString().padLeft(4, '0')}-${createDate.month.toString().padLeft(2, '0')}-${createDate.day.toString().padLeft(2, '0')}",
        "due_date":
            "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
        "payment_status": paymentStatus,
        "payment_method": paymentMethod,
        "bank_id": bankId,
        "type": type,
        "school_id": schoolId,
        "academic_id": academicId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "record_id": recordId,
      };
}

class PaymentMethod {
  PaymentMethod({
    this.method,
  });

  String method;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
      };
}

class StripeInfo {
  StripeInfo({
    this.id,
    this.gatewayName,
    this.gatewayUsername,
    this.gatewayPassword,
    this.gatewaySignature,
    this.gatewayClientId,
    this.gatewayMode,
    this.gatewaySecretKey,
    this.gatewaySecretWord,
    this.gatewayPublisherKey,
    this.gatewayPrivateKey,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.bankDetails,
    this.chequeDetails,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
  });

  int id;
  String gatewayName;
  String gatewayUsername;
  String gatewayPassword;
  dynamic gatewaySignature;
  String gatewayClientId;
  dynamic gatewayMode;
  String gatewaySecretKey;
  String gatewaySecretWord;
  dynamic gatewayPublisherKey;
  dynamic gatewayPrivateKey;
  int activeStatus;
  DateTime createdAt;
  dynamic updatedAt;
  dynamic bankDetails;
  dynamic chequeDetails;
  int createdBy;
  int updatedBy;
  int schoolId;

  factory StripeInfo.fromJson(Map<String, dynamic> json) => StripeInfo(
        id: json["id"],
        gatewayName: json["gateway_name"],
        gatewayUsername: json["gateway_username"],
        gatewayPassword: json["gateway_password"],
        gatewaySignature: json["gateway_signature"],
        gatewayClientId: json["gateway_client_id"],
        gatewayMode: json["gateway_mode"],
        gatewaySecretKey: json["gateway_secret_key"],
        gatewaySecretWord: json["gateway_secret_word"],
        gatewayPublisherKey: json["gateway_publisher_key"],
        gatewayPrivateKey: json["gateway_private_key"],
        activeStatus: json["active_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        bankDetails: json["bank_details"],
        chequeDetails: json["cheque_details"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gateway_name": gatewayName,
        "gateway_username": gatewayUsername,
        "gateway_password": gatewayPassword,
        "gateway_signature": gatewaySignature,
        "gateway_client_id": gatewayClientId,
        "gateway_mode": gatewayMode,
        "gateway_secret_key": gatewaySecretKey,
        "gateway_secret_word": gatewaySecretWord,
        "gateway_publisher_key": gatewayPublisherKey,
        "gateway_private_key": gatewayPrivateKey,
        "active_status": activeStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "bank_details": bankDetails,
        "cheque_details": chequeDetails,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
      };
}
