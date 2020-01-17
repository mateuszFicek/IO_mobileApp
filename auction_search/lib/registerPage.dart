/*Copyright (c) 2020, Michał Kilian, Mateusz Gujda, Mateusz Ficek
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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

/// Strona do rejestracji użytkownika.
/// Zawiera cztery pola: login, email, hasło oraz powtórzone hasło.
/// Pozwala na rejestrację użytkownika oraz daje mu dostęp do głównej części aplikacji.
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

  /// Funkcja, która wysyła zapytanie http na serwer z prośbą o rejestrację użytkownika.
  /// Jeśli zwrócony zostanie kod 200 to użytkownik został poprawnie zarejestrowany i otrzyma możliwość logowania się.
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
      user.setString("password", password);
      user.setString("date", jsonResponse['date'].toString());
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

  /// Formularz, który pobiera od użytkownika login.
  Form buildLoginTextField() {
    return Form(
      key: _formKeyLogin,
      child: TextFormField(
        key: Key('registerLoginForm'),
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

  /// Formularz, który pobiera od użytkownika email oraz sprawdza jego poprawność.
  Form buildEmailTextField() {
    return Form(
      key: _formKeyEmail,
      child: TextFormField(
        key: Key('registerEmailForm'),
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

  /// Formularz, który pobiera od użytkownika hasło.
  Form buildPasswordTextField() {
    return Form(
      key: _formKeyPassword,
      child: TextFormField(
        key: Key('registerPasswordForm'),
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

  /// Formularz, który pobiera od użytkownika hasło ponownie.
  Form buildPasswordAgainTextField() {
    return Form(
      key: _formKeyPasswordAgain,
      child: TextFormField(
        key: Key('registerPasswordAgainForm'),
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
          : SingleChildScrollView(
              child: Stack(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: buildLoginTextField()),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: buildEmailTextField()),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: buildPasswordTextField()),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
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
                                      if (_formKeyLogin.currentState
                                          .validate()) {
                                        validatedData = true;
                                        this._login = _textLogin.text;
                                      } else
                                        validatedData = false;
                                      if (_formKeyEmail.currentState
                                          .validate()) {
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
            ),
    );
  }
}
