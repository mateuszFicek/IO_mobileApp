import 'package:flutter/material.dart';

/// Klasa użytkownik, która zawiera w sobie atrybuty, które określają użytkownika w aplikacji oraz serwerze.

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

  /// Funkcja, która zamienia json otrzymany z serwera na obiekt typu User.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userid: json['id'],
        username: json['username'],
        password: json['password'],
        enabled: json['enabled'],
        email: json['email'],
        date: json['date']);
  }

  String get userName => username;

  int get id => userid;
}
