// To parse this JSON data, do
//
//     final fee = feeFromJson(jsonString);

// Dart imports:
import 'dart:convert';

Fee feeFromJson(String str) => Fee.fromJson(json.decode(str));

String feeToJson(Fee data) => json.encode(data.toJson());

class Fee {
  Fee({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  dynamic message;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.fees,
    this.currencySymbol,
  });

  List<FeeElement> fees;
  CurrencySymbol currencySymbol;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fees: List<FeeElement>.from(json["fees"].map((x) => FeeElement.fromJson(x))),
    currencySymbol: CurrencySymbol.fromJson(json["currency_symbol"]),
  );

  Map<String, dynamic> toJson() => {
    "fees": List<dynamic>.from(fees.map((x) => x.toJson())),
    "currency_symbol": currencySymbol.toJson(),
  };
}

class CurrencySymbol {
  CurrencySymbol({
    this.currencySymbol,
  });

  dynamic currencySymbol;

  factory CurrencySymbol.fromJson(Map<String, dynamic> json) => CurrencySymbol(
    currencySymbol: json["currency_symbol"],
  );

  Map<String, dynamic> toJson() => {
    "currency_symbol": currencySymbol,
  };
}

class FeeElement {
  FeeElement({
    this.feesTypeId,
    this.feesName,
    this.dueDate,
    this.amount,
    this.assignId,
    this.paid,
    this.fine,
    this.discountAmount,
    this.balance,
    this.currencySymbol,
  });

  dynamic feesTypeId;
  dynamic feesName;
  dynamic dueDate;
  dynamic amount;
  dynamic assignId;
  dynamic paid;
  dynamic fine;
  dynamic discountAmount;
  dynamic balance;
  dynamic currencySymbol;

  factory FeeElement.fromJson(Map<String, dynamic> json) => FeeElement(
    feesTypeId: json["fees_type_id"],
    feesName: json["fees_name"],
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    amount: json["amount"],
    assignId: json["assign_id"],
    paid: json["paid"],
    fine: json["fine"],
    discountAmount: json["discount_amount"] == null ? null : json["discount_amount"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "fees_type_id": feesTypeId,
    "fees_name": feesName,
    "due_date":
    "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "paid": paid,
    "fine": fine,
    "discount_amount": discountAmount,
    "balance": balance,
  };
}
