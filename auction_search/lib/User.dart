import 'package:flutter/material.dart';

class User {
  final String username;
  final int userid;
  final String password;
  final int enabled;
  final String email;
  final String date;

  User(
      {this.userid,
      this.username,
      this.password,
      this.enabled,
      this.email,
      this.date});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userid: json['id'],
        username: json['username'],
        password: json['password'],
        enabled: json['enabled'],
        email: json['email'],
        date: json['date']);
  }
}
