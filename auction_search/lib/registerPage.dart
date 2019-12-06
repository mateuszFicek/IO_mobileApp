import 'dart:convert';
import 'dart:io';

import 'package:auction_search/User.dart';
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// TODO:
// - zrobic mozliwosc rejestracji z serwerem
// - poprawic teksty w formularzach

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/registerPage";
  final String title;
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _login;
  String _password;
  String _email;
  String _passwordAgain;
  bool _isLoading = false;

  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPasswordAgain = TextEditingController();

  TextEditingController _textLogin = TextEditingController();
  TextEditingController _textPassword = TextEditingController();

  Future registerNewUser(
      String username, password, passwordAgain, email) async {
    print("Tutaj!");
    SharedPreferences user = await SharedPreferences.getInstance();
    if (password != passwordAgain) {
      print("Wrong passwords");
      return;
    }
    var params = {"username": username, "password": password, "email": email};
    Uri uri = Uri.parse("https://fast-everglades-04594.herokuapp.com/register");
    final newUri = uri.replace(queryParameters: params);

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var jsonResponse;
    var response = await http
        .get(newUri, headers: {HttpHeaders.authorizationHeader: basicAuth});
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      user.setInt("userid", jsonResponse['id']);
      print("Udało się!");
      User currentUser = User.fromJson(jsonResponse);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => CurrentRequests()),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool checkIfPasswordsAreCorrect() {
    if (_password == _passwordAgain) {
      return true;
    } else
      return false;
  }

  TextFormField buildLoginTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _textLogin,
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
      onSaved: (value) => _login = value,
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _textEmail,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Email',
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
      onSaved: (value) => _email = value,
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
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: () {},
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some task';
        }
      },
      onSaved: (value) => _password = value,
    );
  }

  TextFormField buildPasswordAgainTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _textPasswordAgain,
      obscureText: true,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Confirm Password',
          fillColor: Colors.black,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: () {},
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some task';
        }
      },
      onSaved: (value) => _passwordAgain = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
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
                child: buildEmailTextField()),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: buildPasswordTextField()),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: buildPasswordAgainTextField()),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text('You are on a register page!'),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back to prevoius page!'),
            ),
            FlatButton(
              child: Text(
                'Click here to sign in.',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            FlatButton(
              child: Text('Sign up'),
              onPressed: () {
                registerNewUser(_textLogin.text, _textPassword.text,
                    _textPasswordAgain.text, _textEmail.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
