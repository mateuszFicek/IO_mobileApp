import 'package:flutter/material.dart';

class User {
  final String username;
  final String password;

  User({this.username, this.password});

  User.fromJSON(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];
}
