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
import 'package:auction_search/registerPage.dart';
import 'package:auction_search/resources/CustomShapeClipper.dart';
import 'package:auction_search/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Strona do logowania się.
/// Użytkownik posiadający konto może zalogować się poprzez podanie prawidłowego loginu oraz hasła.
/// Jeśli użytkownik nie posiada konta może przejść do strony z rejestracją.
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKeyLogin = GlobalKey<FormState>();
  var _formKeyPassword = GlobalKey<FormState>();

  String _login;
  String _password;
  TextEditingController _textLogin = new TextEditingController();
  TextEditingController _textPassword = new TextEditingController();
  bool _isLoading = false;
  bool validatedData = false;

  /// Funkcja służąca do wysyłania zapytania http na serwer.
  /// Funkcja sprawdza czy podane przez użytkownika dane zgadzają się z danymi w bazie.
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
        user.setInt("userid", jsonResponse['id']);
        user.setString("username", jsonResponse['username']);
        user.setString("password", password);
        user.setString("date", jsonResponse['date'].toString());
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

  /// Formularz, który pobiera od użytkownika login.
  Form buildLoginTextField() {
    return Form(
      key: _formKeyLogin,
      child: TextFormField(
        key: Key("LoginTextField"),
        style: TextStyle(color: fontColor),
        controller: _textLogin,
        autocorrect: false,
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
        onChanged: (value) => _login = value,
      ),
    );
  }

  /// Formularz, który pobiera od hasło login.
  Form buildPasswordTextField() {
    return Form(
      key: _formKeyPassword,
      child: TextFormField(
        key: Key("PasswordTextField"),
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
          if (value.isEmpty) {
            return 'To pole nie może być puste';
          }
        },
        onChanged: (value) => _password = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
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
                                  'Zaloguj się',
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
                                    child: buildPasswordTextField()),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                FlatButton(
                                  key: Key('navigateToRegisterPage'),
                                  child: Text(
                                    'Kliknij tu, aby się zarejestrować',
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage()),
                                    );
                                  },
                                ),
                                FlatButton(
                                    child: Text('Login'),
                                    onPressed: () {
                                      setState(() {
                                        if (_formKeyLogin.currentState
                                                .validate() &&
                                            _formKeyPassword.currentState
                                                .validate()) {
                                          this._login = _textLogin.text;
                                          this._password = _textPassword.text;
                                          validatedData = true;
                                        } else {
                                          validatedData = false;
                                        }
                                        if (validatedData) {
                                          _isLoading = true;
                                        }
                                      });
                                      if (validatedData)
                                        signIn(_login, _password);
                                    }),
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
