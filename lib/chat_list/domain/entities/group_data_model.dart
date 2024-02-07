// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GroupDataModel {
  final String name;
  final List<String> participants;

  GroupDataModel({required this.name, required this.participants});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'participants': participants,
    };
  }

  factory GroupDataModel.fromMap(Map<String, dynamic> map) {
    return GroupDataModel(
      name: map['name'] as String,
      participants: List<String>.from((map['participants'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupDataModel.fromJson(String source) =>
      GroupDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
