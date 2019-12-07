import 'dart:convert';
import 'dart:io';
import 'package:auction_search/User.dart';
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// TODO:
// - pusuwac wszystkie zbedne printy
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/registerPage";
  final String title;
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _login;
  String _password;
  TextEditingController _textLogin = new TextEditingController();
  TextEditingController _textPassword = new TextEditingController();
  bool _isLoading = false;

  signIn(String username, password) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var jsonResponse;
    var response = await http.get(
        "https://fast-everglades-04594.herokuapp.com/login",
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = true;
        });
        print(jsonResponse['user_id']);
        user.setInt("userid", jsonResponse['id']);
        user.setString("username", jsonResponse['username']);
        user.setString("password", password);

        User currentUser = User.fromJson(jsonResponse);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => CurrentRequests()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
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
                      if (_textLogin.text == "" || _textPassword.text == "") {
                        return null;
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        signIn(_textLogin.text, _textPassword.text);
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
