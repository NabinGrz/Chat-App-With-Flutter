// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'chat_list_response.dart';

class Message {
  String? id;
  Sender? sender;
  String? content;
  List<dynamic>? attachments;
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
      attachments: json['attachments'],
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
    data['attachments'] = attachments;
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
