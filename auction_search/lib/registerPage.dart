import 'dart:convert';
import 'dart:io';

import 'package:auction_search/User.dart';
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/loginPage.dart';
import 'package:auction_search/resources/CustomShapeClipper.dart';
import 'package:auction_search/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  var _formKeyLogin = GlobalKey<FormState>();
  var _formKeyPassword = GlobalKey<FormState>();
  var _formKeyPasswordAgain = GlobalKey<FormState>();
  var _formKeyEmail = GlobalKey<FormState>();

  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPasswordAgain = TextEditingController();

  TextEditingController _textLogin = TextEditingController();
  TextEditingController _textPassword = TextEditingController();

  bool validatedData;

  Future registerNewUser(String username, String password, String passwordAgain,
      String email) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if (password != passwordAgain) {
      setState(() {
        _isLoading = false;
      });
      return "Hasła nie są identyczne";
    }
    var params = {"username": username, "password": password, "email": email};
    var jsonResponse;
    var response = await http.post(
        "https://fast-everglades-04594.herokuapp.com/register",
        body: json.encode(params),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      user.setInt("userid", jsonResponse['id']);
      user.setString("username", jsonResponse['username']);
      user.setString("email", jsonResponse['email']);
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

  Form buildLoginTextField() {
    return Form(
      key: _formKeyLogin,
      child: TextFormField(
        style: TextStyle(color: fontColor),
        controller: _textLogin,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cardBorderColor, width: 0.0),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            hintText: 'Login',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _textLogin.clear();
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'To pole nie może być puste';
          }
        },
        onSaved: (value) => _login = value,
      ),
    );
  }

  Form buildEmailTextField() {
    return Form(
      key: _formKeyEmail,
      child: TextFormField(
        style: TextStyle(color: fontColor),
        controller: _textEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cardBorderColor, width: 0.0),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            hintText: 'Email',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _textEmail.clear();
              },
            )),
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            return 'Wprowadź poprawny email';
          else
            return null;
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Form buildPasswordTextField() {
    return Form(
      key: _formKeyPassword,
      child: TextFormField(
        style: TextStyle(color: fontColor),
        controller: _textPassword,
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cardBorderColor, width: 0.0),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            hintText: 'Hasło',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _textPassword.clear();
              },
            )),
        validator: (value) {
          if (value.length < 6) {
            return 'Hasło nie może mieć mniej niż 6 znaków';
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Form buildPasswordAgainTextField() {
    return Form(
      key: _formKeyPasswordAgain,
      child: TextFormField(
        style: TextStyle(color: fontColor),
        controller: _textPasswordAgain,
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cardBorderColor, width: 0.0),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            hintText: 'Potwierdź hasło',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _textPasswordAgain.clear();
              },
            )),
        validator: (value) {
          if (value.isEmpty) return 'To pole nie może być puste';
          if (value != _password) return 'Hasła się nie zgadzają';
        },
        onSaved: (value) => _passwordAgain = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      ClipPath(
                        clipper: CustomShapeClipper(),
                        child: Container(
                          color: primaryBlue,
                          height: 250,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Zarejestruj się',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 250,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: buildLoginTextField()),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: buildEmailTextField()),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: buildPasswordTextField()),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: buildPasswordAgainTextField()),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              FlatButton(
                                child: Text(
                                  'Kliknij tu, aby się zalogować',
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                              ),
                              FlatButton(
                                child: Text('Zarejestruj się'),
                                onPressed: () {
                                  setState(() {
                                    if (_formKeyLogin.currentState.validate()) {
                                      validatedData = true;
                                      this._login = _textLogin.text;
                                    } else
                                      validatedData = false;
                                    if (_formKeyEmail.currentState.validate()) {
                                      validatedData = true;
                                      this._email = _textEmail.text;
                                    } else
                                      validatedData = false;
                                    if (_formKeyPassword.currentState
                                        .validate()) {
                                      validatedData = true;
                                      this._password = _textPassword.text;
                                    } else
                                      validatedData = false;
                                    if (_formKeyPasswordAgain.currentState
                                        .validate()) {
                                      validatedData = true;
                                      this._passwordAgain =
                                          _textPasswordAgain.text;
                                    } else
                                      validatedData = false;
                                    if (validatedData) {
                                      _isLoading = true;
                                    }
                                  });
                                  if (validatedData)
                                    registerNewUser(_login, _password,
                                        _passwordAgain, _email);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
