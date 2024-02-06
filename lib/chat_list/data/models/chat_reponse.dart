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

  String? get senderUsername => lastMessage?.sender?.username;
  DateTime get lastMsgDate => lastMessage?.createdAt ?? DateTime.now();
  String? get content => lastMessage?.content;
  String? get lastParticipantName => participants?.last.username;
  bool get isGrpChatAndHasLastMessage =>
      isGroupChat == true && lastMessage != null;
  bool get hasNewChat => newChatCount > 0;
  String get senderMessage => "$senderUsername: $content";
  String get msgOrNo => content ?? "No message yet";
  String get chatSubtitle =>
      isGrpChatAndHasLastMessage ? senderMessage : msgOrNo;
  String? get chatTitle => isGroupChat == true ? name : lastParticipantName;
  DateTime? get chatTime => createdAt;
  DateTime? get chatUTime => updatedAt;
  Duration get differenceD => DateTime.now().difference(lastMsgDate);

  String get time => differenceD.inHours > 0
      ? "${differenceD.inHours} hours"
      : differenceD.inMinutes > 0
          ? "${differenceD.inMinutes} minutes"
          : "a few seconds";
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
}
