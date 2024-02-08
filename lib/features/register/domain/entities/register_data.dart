// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegisterData {
  final String username;
  final String password;
  final String email;

  RegisterData(
      {required this.username, required this.password, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'email': email,
    };
  }

  factory RegisterData.fromMap(Map<String, dynamic> map) {
    return RegisterData(
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterData.fromJson(String source) =>
      RegisterData.fromMap(json.decode(source) as Map<String, dynamic>);
}
