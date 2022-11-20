// To parse this JSON data, do
//
//     final studentAddPaymentModel = studentAddPaymentModelFromJson(jsonString);

import 'dart:convert';

StudentAddPaymentModel studentAddPaymentModelFromJson(String str) =>
    StudentAddPaymentModel.fromJson(json.decode(str));

String studentAddPaymentModelToJson(StudentAddPaymentModel data) =>
    json.encode(data.toJson());

class StudentAddPaymentModel {
  StudentAddPaymentModel({
    this.paymentMethods,
    this.bankAccounts,
    this.invoiceInfo,
    this.invoiceDetails,
    this.stripeInfo,
  });

  List<FeesPaymentMethod> paymentMethods;
  List<BankAccount> bankAccounts;
  InvoiceInfo invoiceInfo;
  List<InvoiceDetail> invoiceDetails;
  StripeInfo stripeInfo;

  factory StudentAddPaymentModel.fromJson(Map<String, dynamic> json) =>
      StudentAddPaymentModel(
        paymentMethods: List<FeesPaymentMethod>.from(
            json["paymentMethods"].map((x) => FeesPaymentMethod.fromJson(x))),
        bankAccounts: List<BankAccount>.from(
            json["bankAccounts"].map((x) => BankAccount.fromJson(x))),
        invoiceInfo: InvoiceInfo.fromJson(json["invoiceInfo"]),
        invoiceDetails: List<InvoiceDetail>.from(
            json["invoiceDetails"].map((x) => InvoiceDetail.fromJson(x))),
        stripeInfo: StripeInfo.fromJson(json["stripe_info"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentMethods":
            List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "bankAccounts": List<dynamic>.from(bankAccounts.map((x) => x.toJson())),
        "invoiceInfo": invoiceInfo.toJson(),
        "invoiceDetails":
            List<dynamic>.from(invoiceDetails.map((x) => x.toJson())),
        "stripe_info": stripeInfo.toJson(),
      };
}

class BankAccount {
  BankAccount({
    this.id,
    this.bankName,
    this.accountNumber,
  });

  int id;
  String bankName;
  String accountNumber;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "account_number": accountNumber,
      };
}

class InvoiceDetail {
  InvoiceDetail({
    this.feesType,
    this.feesTypeName,
    this.amount,
    this.dueAmount,
    this.weaver,
    this.fine,
    this.note,
  });

  int feesType;
  String feesTypeName;
  double amount;
  double dueAmount;
  double weaver;
  double fine;
  String note;

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        feesType: json["fees_type"],
        feesTypeName: json["fees_type_name"],
        amount: json["amount"].toDouble(),
        dueAmount: json["due_amount"].toDouble(),
        weaver: json["weaver"] == null ? 0.0 : json["weaver"].toDouble(),
        fine: json["fine"] == null ? 0.0 : json["fine"].toDouble(),
        note: json["note"] == null ? "" : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "fees_type": feesType,
        "fees_type_name": feesTypeName,
        "amount": amount,
        "due_amount": dueAmount,
        "weaver": weaver,
        "fine": fine,
        "note": note,
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
    this.studentInfo,
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
  StudentInfo studentInfo;

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
        studentInfo: StudentInfo.fromJson(json["student_info"]),
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
        "student_info": studentInfo.toJson(),
      };
}

class StudentInfo {
  StudentInfo({
    this.id,
    this.user,
  });
  int id;
  User user;

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
        id: json["id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
      };
}

class User {
  User({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.walletBalance,
    this.phoneNumber,
    this.firstName,
    this.avatarUrl,
    this.blockedByMe,
  });

  int id;
  String fullName;
  String username;
  String email;
  double walletBalance;
  String phoneNumber;
  String firstName;
  String avatarUrl;
  bool blockedByMe;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        username: json["username"],
        email: json["email"],
        walletBalance: json["wallet_balance"].toDouble(),
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
        "wallet_balance": walletBalance,
        "phone_number": phoneNumber,
        "first_name": firstName,
        "avatar_url": avatarUrl,
        "blocked_by_me": blockedByMe,
      };
}

class FeesPaymentMethod {
  FeesPaymentMethod({
    this.paymentMethod,
  });

  String paymentMethod;

  factory FeesPaymentMethod.fromJson(Map<String, dynamic> json) =>
      FeesPaymentMethod(
        paymentMethod: json["payment_method"],
      );

  Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod,
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
