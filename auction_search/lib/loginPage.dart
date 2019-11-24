import 'package:auction_search/currentQueries.dart';
import 'package:auction_search/registerPage.dart';
import 'package:flutter/material.dart';

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
              },
            ),
          ],
        ),
      ),
    );
  }
}
