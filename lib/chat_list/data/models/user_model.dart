// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'chat_list_response.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? statusCode;
  List<Datum>? data;
  String? message;
  bool? success;
  String? error;
  UserModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
    this.error,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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
}

class Datum {
  String? id;
  Avatar? avatar;
  String? username;
  String? email;

  Datum({
    this.id,
    this.avatar,
    this.username,
    this.email,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

  @override
  String toString() {
    return 'Datum(id: $id, avatar: $avatar, username: $username, email: $email)';
  }
}
