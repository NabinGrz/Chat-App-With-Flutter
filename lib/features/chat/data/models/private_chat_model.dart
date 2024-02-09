// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final privateChatModel = privateChatModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_chat_app/features/chat_list/data/models/message_reponse.dart';


PrivateChatModel privateChatModelFromJson(String str) =>
    PrivateChatModel.fromJson(json.decode(str));

String privateChatModelToJson(PrivateChatModel data) =>
    json.encode(data.toJson());

class PrivateChatModel {
  int? statusCode;
  List<Message>? data;
  String? message;
  String? error;
  bool? success;

  PrivateChatModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
    this.error,
  });

  factory PrivateChatModel.fromJson(Map<String, dynamic> json) =>
      PrivateChatModel(
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? []
            : List<Message>.from(json["data"]!.map((x) => Message.fromJson(x))),
        message: json["message"],
        error: json["error"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "error": error,
        "success": success,
      };

  @override
  String toString() {
    return 'PrivateChatModel(statusCode: $statusCode, data: $data, message: $message, error: $error, success: $success)';
  }
}
