// To parse this JSON data, do
//
//     final xenditErrorResponse = xenditErrorResponseFromJson(jsonString);

import 'dart:convert';

XenditErrorResponse xenditErrorResponseFromJson(String str) => XenditErrorResponse.fromJson(json.decode(str));

String xenditErrorResponseToJson(XenditErrorResponse data) => json.encode(data.toJson());

class XenditErrorResponse {
  XenditErrorResponse({
    this.errorCode,
    this.message,
    this.errors,
  });

  String errorCode;
  String message;
  List<Error> errors;

  factory XenditErrorResponse.fromJson(Map<String, dynamic> json) => XenditErrorResponse(
    errorCode: json["error_code"],
    message: json["message"],
    errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error_code": errorCode,
    "message": message,
    "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
  };
}

class Error {
  Error({
    this.message,
    this.path,
    this.type,
    this.context,
  });

  String message;
  List<String> path;
  String type;
  Context context;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    message: json["message"],
    path: List<String>.from(json["path"].map((x) => x)),
    type: json["type"],
    context: Context.fromJson(json["context"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "path": List<dynamic>.from(path.map((x) => x)),
    "type": type,
    "context": context.toJson(),
  };
}

class Context {
  Context({
    this.value,
    this.key,
    this.label,
  });

  String value;
  String key;
  String label;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
    value: json["value"],
    key: json["key"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
    "label": label,
  };
}
