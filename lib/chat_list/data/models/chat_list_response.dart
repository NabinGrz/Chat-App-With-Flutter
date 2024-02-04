// To parse this JSON data, do
//
//     final chatListResponse = chatListResponseFromJson(jsonString);

import 'dart:convert';

ChatListResponse chatListResponseFromJson(String str) =>
    ChatListResponse.fromJson(json.decode(str));

String chatListResponseToJson(ChatListResponse data) =>
    json.encode(data.toJson());

class ChatListResponse {
  int? statusCode;
  List<Datum>? data;
  String? message;
  bool? success;

  ChatListResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) =>
      ChatListResponse(
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "success": success,
      };
}

class Datum {
  String? id;
  String? name;
  bool? isGroupChat;
  List<Participant>? participants;
  String? admin;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  LastMessage? lastMessage;

  Datum({
    this.id,
    this.name,
    this.isGroupChat,
    this.participants,
    this.admin,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastMessage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        isGroupChat: json["isGroupChat"],
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x))),
        admin: json["admin"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        lastMessage: json["lastMessage"] == null
            ? null
            : LastMessage.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "isGroupChat": isGroupChat,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "admin": admin,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "lastMessage": lastMessage?.toJson(),
      };
}

class LastMessage {
  String? id;
  Sender? sender;
  String? content;
  List<dynamic>? attachments;
  String? chat;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  LastMessage({
    this.id,
    this.sender,
    this.content,
    this.attachments,
    this.chat,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["_id"],
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        content: json["content"],
        attachments: json["attachments"] == null
            ? []
            : List<dynamic>.from(json["attachments"]!.map((x) => x)),
        chat: json["chat"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sender": sender?.toJson(),
        "content": content,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x)),
        "chat": chat,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
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

class Participant {
  String? id;
  Avatar? avatar;
  String? username;
  String? email;
  String? role;
  String? loginType;
  bool? isEmailVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Participant({
    this.id,
    this.avatar,
    this.username,
    this.email,
    this.role,
    this.loginType,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["_id"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        username: json["username"],
        email: json["email"],
        role: json["role"],
        loginType: json["loginType"],
        isEmailVerified: json["isEmailVerified"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar?.toJson(),
        "username": username,
        "email": email,
        "role": role,
        "loginType": loginType,
        "isEmailVerified": isEmailVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
