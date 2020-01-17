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
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/loginPage.dart';
import 'package:auction_search/registerPage.dart';
import 'package:auction_search/resources/CustomShapeClipper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auction_search/resources/colors.dart';

void main() => runApp(MyApp());

/// Strona główna aplikacji.
/// Zawiera dwa przyciski, które pozwalają przejść do strony logowania lub rejestracji.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Auction Search',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Oxygen",
            backgroundColor: Colors.grey),
        home: FutureBuilder<bool>(
          future: showLoginPage(),
          builder: (context, snapshot) {
            if (snapshot.hasData == true) {
              if (snapshot.data) {
                return CurrentRequests();
              } else {
                return MyHomePage(title: 'Main Screen');
              }
            } else {
              return MyHomePage(
                title: 'Main Screen',
              );
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// Funkcja, która sprawdza czy użytkownik już się zalogował.
/// Zwraca true jeśli na urządzeniu znajdują się dane użytkownika.
Future<bool> showLoginPage() async {
  var userLogged = await SharedPreferences.getInstance();
  String user = userLogged.getString('username');
  if (user == null) {
    return false;
  }
  return true;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                  color: primaryBlue,
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Witaj w',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      Text('Hunto',
                          style: TextStyle(fontSize: 100, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        key: Key('loginFromMainPageKey'),
                        child: Text(
                          'Zaloguj się',
                          style: TextStyle(fontSize: 20),
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
                        key: Key('registerFromMainPageKey'),
                        child: Text(
                          'Zarejestruj się',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
