// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'chat_list_response.dart';

class Message {
  String? id;
  Sender? sender;
  String? content;
  List<Attachment>? attachments;
  String? chat;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Message({
    this.id,
    this.sender,
    this.content,
    this.attachments,
    this.chat,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      content: json['content'],
      attachments: json["attachments"] == null
          ? []
          : List<Attachment>.from(
              json["attachments"]!.map((x) => Attachment.fromJson(x))),
      chat: json['chat'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['sender'] = sender != null ? sender!.toJson() : null;
    data['content'] = content;
    data['attachments'] = attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x.toJson()));
    data['chat'] = chat;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['__v'] = v;
    return data;
  }

  @override
  String toString() {
    return 'Message(id: $id, sender: $sender, content: $content, attachments: $attachments, chat: $chat, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }
}

class Attachment {
  String? url;
  String? localPath;
  String? id;

  Attachment({
    this.url,
    this.localPath,
    this.id,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
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
