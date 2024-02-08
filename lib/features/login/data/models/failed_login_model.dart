// To parse this JSON data, do
//
//     final failedLoginResponse = failedLoginResponseFromJson(jsonString);

import 'dart:convert';

FailedLoginResponse failedLoginResponseFromJson(String str) =>
    FailedLoginResponse.fromJson(json.decode(str));

String failedLoginResponseToJson(FailedLoginResponse data) =>
    json.encode(data.toJson());

class FailedLoginResponse {
  int? statusCode;
  dynamic data;
  bool? success;
  List<dynamic>? errors;
  String? message;
  String? stack;

  FailedLoginResponse({
    this.statusCode,
    this.data,
    this.success,
    this.errors,
    this.message,
    this.stack,
  });

  factory FailedLoginResponse.fromJson(Map<String, dynamic> json) =>
      FailedLoginResponse(
        statusCode: json["statusCode"],
        data: json["data"],
        success: json["success"],
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        message: json["message"],
        stack: json["stack"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data,
        "success": success,
        "errors":
            errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
        "message": message,
        "stack": stack,
      };
}
