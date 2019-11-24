import 'package:auction_search/loginPage.dart';
import 'package:flutter/material.dart';

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
  TextEditingController _textLogin = TextEditingController();
  TextEditingController _textPassword = TextEditingController();
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
          ],
        ),
      ),
    );
  }
}
