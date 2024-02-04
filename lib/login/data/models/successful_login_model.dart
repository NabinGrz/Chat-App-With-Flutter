// To parse this JSON data, do
//
//     final successfullLoginResponse = successfullLoginResponseFromJson(jsonString);

import 'dart:convert';

SuccessfullLoginResponse successfullLoginResponseFromJson(String str) =>
    SuccessfullLoginResponse.fromJson(json.decode(str));

String successfullLoginResponseToJson(SuccessfullLoginResponse data) =>
    json.encode(data.toJson());

class SuccessfullLoginResponse {
  int statusCode;
  Data data;
  String message;
  bool success;

  SuccessfullLoginResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory SuccessfullLoginResponse.fromJson(Map<String, dynamic> json) =>
      SuccessfullLoginResponse(
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
        "message": message,
        "success": success,
      };
}

class Data {
  User user;
  String accessToken;
  String refreshToken;

  Data({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class User {
  String id;
  Avatar avatar;
  String username;
  String email;
  String role;
  String loginType;
  bool isEmailVerified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  User({
    required this.id,
    required this.avatar,
    required this.username,
    required this.email,
    required this.role,
    required this.loginType,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        avatar: Avatar.fromJson(json["avatar"]),
        username: json["username"],
        email: json["email"],
        role: json["role"],
        loginType: json["loginType"],
        isEmailVerified: json["isEmailVerified"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar.toJson(),
        "username": username,
        "email": email,
        "role": role,
        "loginType": loginType,
        "isEmailVerified": isEmailVerified,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Avatar {
  String url;
  String localPath;
  String id;

  Avatar({
    required this.url,
    required this.localPath,
    required this.id,
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
