// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/chat_list/data/models/message_reponse.dart';

import 'chat_list_response.dart';

class Chat {
  String? id;
  String? name;
  bool? isGroupChat;
  List<Participant>? participants;
  String? admin;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Message? lastMessage;
  bool? isNewChat;
  int newChatCount;
  Chat({
    this.id,
    this.name,
    this.isGroupChat,
    this.participants,
    this.admin,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastMessage,
    this.isNewChat = false,
    this.newChatCount = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
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
        isNewChat: json["isNewChat"] ?? false,
        newChatCount: json["newChatCount"] ?? 0,
        lastMessage: json["lastMessage"] == null
            ? null
            : Message.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isNewChat": isNewChat,
        "name": name,
        "isGroupChat": isGroupChat ?? false,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "admin": admin,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "newChatCount": newChatCount,
        "__v": v,
        "lastMessage": lastMessage?.toJson(),
      };

  @override
  String toString() {
    return 'Chat(id: $id, name: $name, isGroupChat: $isGroupChat, participants: $participants, admin: $admin, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, lastMessage: $lastMessage)';
  }

  Chat copyWith(
      {String? id,
      String? name,
      bool? isGroupChat,
      List<Participant>? participants,
      String? admin,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? v,
      Message? lastMessage,
      bool? isNewChat,
      int? newChatCount}) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      participants: participants ?? this.participants,
      admin: admin ?? this.admin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      lastMessage: lastMessage ?? this.lastMessage,
      isNewChat: isNewChat ?? this.isNewChat,
      newChatCount: (newChatCount ?? this.newChatCount) ?? 0 + 1,
    );
  }
}
