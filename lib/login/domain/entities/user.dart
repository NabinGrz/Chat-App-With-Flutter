// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserCredentials {
  final String username;
  final String password;

  UserCredentials({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  factory UserCredentials.fromMap(Map<String, dynamic> map) {
    return UserCredentials(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCredentials.fromJson(String source) =>
      UserCredentials.fromMap(json.decode(source) as Map<String, dynamic>);
}
