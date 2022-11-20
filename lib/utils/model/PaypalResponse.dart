// To parse this JSON data, do
//
//     final paypalResponse = paypalResponseFromJson(jsonString);

// Dart imports:
import 'dart:convert';

PaypalResponse paypalResponseFromJson(String str) => PaypalResponse.fromJson(json.decode(str));

String paypalResponseToJson(PaypalResponse data) => json.encode(data.toJson());

class PaypalResponse {
  PaypalResponse({
    this.id,
    this.intent,
    this.state,
    this.cart,
    this.payer,
    this.transactions,
    this.failedTransactions,
    this.createTime,
    this.updateTime,
    this.links,
  });

  String id;
  String intent;
  String state;
  String cart;
  Payer payer;
  List<Transaction> transactions;
  List<dynamic> failedTransactions;
  DateTime createTime;
  DateTime updateTime;
  List<Link> links;

  factory PaypalResponse.fromJson(Map<String, dynamic> json) => PaypalResponse(
    id: json["id"],
    intent: json["intent"],
    state: json["state"],
    cart: json["cart"],
    payer: Payer.fromJson(json["payer"]),
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
    failedTransactions: List<dynamic>.from(json["failed_transactions"].map((x) => x)),
    createTime: DateTime.parse(json["create_time"]),
    updateTime: DateTime.parse(json["update_time"]),
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "intent": intent,
    "state": state,
    "cart": cart,
    "payer": payer.toJson(),
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
    "failed_transactions": List<dynamic>.from(failedTransactions.map((x) => x)),
    "create_time": createTime.toIso8601String(),
    "update_time": updateTime.toIso8601String(),
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
  };
}

class Link {
  Link({
    this.href,
    this.rel,
    this.method,
  });

  String href;
  String rel;
  String method;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    href: json["href"],
    rel: json["rel"],
    method: json["method"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "rel": rel,
    "method": method,
  };
}

class Payer {
  Payer({
    this.paymentMethod,
    this.status,
    this.payerInfo,
  });

  String paymentMethod;
  String status;
  PayerInfo payerInfo;

  factory Payer.fromJson(Map<String, dynamic> json) => Payer(
    paymentMethod: json["payment_method"],
    status: json["status"],
    payerInfo: PayerInfo.fromJson(json["payer_info"]),
  );

  Map<String, dynamic> toJson() => {
    "payment_method": paymentMethod,
    "status": status,
    "payer_info": payerInfo.toJson(),
  };
}

class PayerInfo {
  PayerInfo({
    this.email,
    this.firstName,
    this.lastName,
    this.payerId,
    this.shippingAddress,
    this.countryCode,
  });

  String email;
  String firstName;
  String lastName;
  String payerId;
  ShippingAddress shippingAddress;
  String countryCode;

  factory PayerInfo.fromJson(Map<String, dynamic> json) => PayerInfo(
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    payerId: json["payer_id"],
    shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "payer_id": payerId,
    "shipping_address": shippingAddress.toJson(),
    "country_code": countryCode,
  };
}

class ShippingAddress {
  ShippingAddress({
    this.recipientName,
    this.line1,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
  });

  String recipientName;
  String line1;
  String city;
  String state;
  String postalCode;
  String countryCode;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    recipientName: json["recipient_name"],
    line1: json["line1"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postal_code"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "recipient_name": recipientName,
    "line1": line1,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country_code": countryCode,
  };
}

class Transaction {
  Transaction({
    this.amount,
    this.payee,
    this.description,
    this.itemList,
    this.relatedResources,
  });

  Amount amount;
  Payee payee;
  String description;
  ItemList itemList;
  List<RelatedResource> relatedResources;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    amount: Amount.fromJson(json["amount"]),
    payee: Payee.fromJson(json["payee"]),
    description: json["description"],
    itemList: ItemList.fromJson(json["item_list"]),
    relatedResources: List<RelatedResource>.from(json["related_resources"].map((x) => RelatedResource.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount.toJson(),
    "payee": payee.toJson(),
    "description": description,
    "item_list": itemList.toJson(),
    "related_resources": List<dynamic>.from(relatedResources.map((x) => x.toJson())),
  };
}

class Amount {
  Amount({
    this.total,
    this.currency,
    this.details,
  });

  String total;
  String currency;
  Details details;

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
    total: json["total"],
    currency: json["currency"],
    details: Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "currency": currency,
    "details": details.toJson(),
  };
}

class Details {
  Details({
    this.subtotal,
    this.tax,
    this.shipping,
    this.insurance,
    this.handlingFee,
    this.shippingDiscount,
    this.discount,
  });

  String subtotal;
  String tax;
  String shipping;
  String insurance;
  String handlingFee;
  String shippingDiscount;
  String discount;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    subtotal: json["subtotal"],
    tax: json["tax"],
    shipping: json["shipping"],
    insurance: json["insurance"],
    handlingFee: json["handling_fee"],
    shippingDiscount: json["shipping_discount"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal,
    "tax": tax,
    "shipping": shipping,
    "insurance": insurance,
    "handling_fee": handlingFee,
    "shipping_discount": shippingDiscount,
    "discount": discount,
  };
}

class ItemList {
  ItemList({
    this.items,
    this.shippingAddress,
    this.shippingPhoneNumber,
  });

  List<Item> items;
  ShippingAddress shippingAddress;
  String shippingPhoneNumber;

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
    shippingPhoneNumber: json["shipping_phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "shipping_address": shippingAddress.toJson(),
    "shipping_phone_number": shippingPhoneNumber,
  };
}

class Item {
  Item({
    this.name,
    this.sku,
    this.price,
    this.currency,
    this.tax,
    this.quantity,
  });

  String name;
  String sku;
  String price;
  String currency;
  String tax;
  int quantity;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    name: json["name"],
    sku: json["sku"],
    price: json["price"],
    currency: json["currency"],
    tax: json["tax"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sku": sku,
    "price": price,
    "currency": currency,
    "tax": tax,
    "quantity": quantity,
  };
}

class Payee {
  Payee({
    this.merchantId,
    this.email,
  });

  String merchantId;
  String email;

  factory Payee.fromJson(Map<String, dynamic> json) => Payee(
    merchantId: json["merchant_id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "merchant_id": merchantId,
    "email": email,
  };
}

class RelatedResource {
  RelatedResource({
    this.sale,
  });

  Sale sale;

  factory RelatedResource.fromJson(Map<String, dynamic> json) => RelatedResource(
    sale: Sale.fromJson(json["sale"]),
  );

  Map<String, dynamic> toJson() => {
    "sale": sale.toJson(),
  };
}

class Sale {
  Sale({
    this.id,
    this.state,
    this.amount,
    this.paymentMode,
    this.protectionEligibility,
    this.protectionEligibilityType,
    this.transactionFee,
    this.parentPayment,
    this.createTime,
    this.updateTime,
    this.links,
  });

  String id;
  String state;
  Amount amount;
  String paymentMode;
  String protectionEligibility;
  String protectionEligibilityType;
  TransactionFee transactionFee;
  String parentPayment;
  DateTime createTime;
  DateTime updateTime;
  List<Link> links;

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    id: json["id"],
    state: json["state"],
    amount: Amount.fromJson(json["amount"]),
    paymentMode: json["payment_mode"],
    protectionEligibility: json["protection_eligibility"],
    protectionEligibilityType: json["protection_eligibility_type"],
    transactionFee: TransactionFee.fromJson(json["transaction_fee"]),
    parentPayment: json["parent_payment"],
    createTime: DateTime.parse(json["create_time"]),
    updateTime: DateTime.parse(json["update_time"]),
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state": state,
    "amount": amount.toJson(),
    "payment_mode": paymentMode,
    "protection_eligibility": protectionEligibility,
    "protection_eligibility_type": protectionEligibilityType,
    "transaction_fee": transactionFee.toJson(),
    "parent_payment": parentPayment,
    "create_time": createTime.toIso8601String(),
    "update_time": updateTime.toIso8601String(),
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
  };
}

class TransactionFee {
  TransactionFee({
    this.value,
    this.currency,
  });

  String value;
  String currency;

  factory TransactionFee.fromJson(Map<String, dynamic> json) => TransactionFee(
    value: json["value"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "currency": currency,
  };
}
