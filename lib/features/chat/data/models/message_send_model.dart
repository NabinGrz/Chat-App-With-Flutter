// To parse this JSON data, do
//
//     final messageSendResponse = messageSendResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_chat_app/features/chat_list/data/models/message_reponse.dart';

MessageSendResponse messageSendResponseFromJson(String str) =>
    MessageSendResponse.fromJson(json.decode(str));

String messageSendResponseToJson(MessageSendResponse data) =>
    json.encode(data.toJson());

class MessageSendResponse {
  int? statusCode;
  Message? data;
  String? message;
  bool? success;

  MessageSendResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory MessageSendResponse.fromJson(Map<String, dynamic> json) =>
      MessageSendResponse(
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Message.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
        "success": success,
      };
}

class Sender {
  String? id;
  Avatar? avatar;
  String? username;
  String? email;

  Sender({
    this.id,
    this.avatar,
    this.username,
    this.email,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["_id"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar?.toJson(),
        "username": username,
        "email": email,
      };
}

class Avatar {
  String? url;
  String? localPath;
  String? id;

  Avatar({
    this.url,
    this.localPath,
    this.id,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        url: json["url"],
        localPath: json["localPath"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "localPath": localPath,
        "_id": id,
      };
}
