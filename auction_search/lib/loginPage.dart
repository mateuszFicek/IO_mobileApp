import 'dart:convert';

import 'package:auction_search/currentQueries.dart';
import 'package:auction_search/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/registerPage";
  final String title;
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class FakeUser {
  static String userName = "abc";
  static String password = "abc";
}

class _LoginPageState extends State<LoginPage> {
  String _login;
  String _password;
  TextEditingController _textLogin = new TextEditingController();
  TextEditingController _textPassword = new TextEditingController();
  bool _isLoading = false;

  signIn(String username, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': username, 'password': password};

    var jsonResponse;
    //ZMIENIC URL NA NASZ SERWER
    var response = await http.post("URL", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => CurrentQueries()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  TextFormField buildLoginTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _textLogin,
      autocorrect: false,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Login',
          fillColor: Colors.black,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.black),
            onPressed: () {},
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some task';
        }
      },
      onChanged: (value) => _login = value,
    );
  }

  TextFormField buildPasswordTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _textPassword,
      obscureText: true,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Password',
          fillColor: Colors.black,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.black),
            onPressed: () {
              print(_password);
            },
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some task';
        }
      },
      onChanged: (value) => _password = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: buildLoginTextField()),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: buildPasswordTextField()),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text('You are on a login page!'),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go back to prevoius page!'),
                  ),
                  FlatButton(
                    child: Text(
                      'Click here to sign up.',
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text('Check?'),
                    onPressed: () {
                      if (FakeUser.password == _password &&
                          FakeUser.userName == _login) {
                        print("Poprawne");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CurrentQueries()));
                      } else {
                        print('Niepoprawne');
                      }
                      // ZROBIONE JAK JUZ BEDZIE MOZNA SIE LOGOWAC Z SERWERA
                      // if (_textLogin.text == "" || _textPassword.text == "") {
                      //   return null;
                      // } else {
                      //   setState(() {
                      //     _isLoading = true;
                      //   });
                      //   signIn(_textLogin.text, _textPassword.text);
                      // }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
