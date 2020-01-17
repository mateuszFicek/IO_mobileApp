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
import 'dart:developer';
import 'dart:io';
import 'package:auction_search/addNewRequestPage.dart';
import 'package:auction_search/main.dart';
import 'package:auction_search/resources/CustomShapeClipper.dart';
import 'package:auction_search/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auction_search/request.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

/// Strona z aktualnie przetwarzanymi zapytaniami.
/// Użytkownik ma do niej dostęp tylko po zalogowaniu.
/// Możliwość wylogowania oraz przejścia do strony gdzie można dodać nowe zapytanie.
class CurrentRequests extends StatefulWidget {
  CurrentRequests({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CurrentRequestsState createState() => new _CurrentRequestsState();
}

/// Usuwa dane użytkownika z pamięci urządzenia.
Future clearUser() async {
  final SharedPreferences user = await SharedPreferences.getInstance();
  user.clear();
  return true;
}

/// Funkcja, która wysyła zapytanie http, które usuwa Requesty.
Future deleteRequest(int requestId) async {
  SharedPreferences user = await SharedPreferences.getInstance();
  String username = user.getString('username');
  String password = user.getString('password');
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  var response = await http.delete(
      "https://fast-everglades-04594.herokuapp.com/request/$requestId",
      headers: {HttpHeaders.authorizationHeader: basicAuth});
}

/// Funkcja, która wysyła zapytanie http, które zmienia status Requestu.
Future changeRequestStatus(int requestId, String newStatus) async {
  SharedPreferences user = await SharedPreferences.getInstance();
  String username = user.getString('username');
  String password = user.getString('password');
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  var response = await http.put(
      "https://fast-everglades-04594.herokuapp.com/request/$requestId/state/$newStatus",
      headers: {HttpHeaders.authorizationHeader: basicAuth});
}

/// Widget pojedynczej karty, która zawiera dane o zapytaniu.
/// Użytkownik ma możliwość sprawdzenia stanu zapytania, tytułu oraz ceny maksymalnej.
/// Funkcja bezpośredniego linku do aukcji.
Card buildItemCard(Request request) {
  return Card(
    margin: EdgeInsets.all(10.0),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: cardBorderColor)),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${request.description}',
            style: TextStyle(
                fontSize: 16, color: fontColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(children: <Widget>[
            Icon(
              Icons.monetization_on,
              size: 16,
              color: Colors.grey,
            ),
            Text(
              ' ${request.price.toString()}',
              style: TextStyle(fontSize: 12, color: fontColor),
            ),
          ]),
          SizedBox(height: 2),
          Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
                size: 16,
                color: Colors.grey,
              ),
              Text(
                ' ${request.creationDate.substring(0, 10)}',
                style: TextStyle(fontSize: 12, color: fontColor),
              )
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: <Widget>[
              Icon(
                Icons.info,
                size: 16,
                color: Colors.grey,
              ),
              Text(
                ' ${request.status}',
                style: TextStyle(fontSize: 12, color: fontColor),
              )
            ],
          ),
          SizedBox(height: 2),
          request.auctionLinkAllegro == null
              ? Text(
                  "Allegro - Aukcji jeszcze nie odnaleziono",
                  style: TextStyle(fontSize: 12, color: fontColor),
                )
              : FlatButton(
                  onPressed: () async {
                    var url = request.auctionLinkAllegro.toString();
                    if (await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Allegro - Naciśnij, aby przejść do aukcji",
                    style: TextStyle(fontSize: 12, color: fontColor),
                  ),
                ),
          request.auctionLinkEbay == null
              ? Text(
                  "Ebay - Aukcji jeszcze nie odnaleziono",
                  style: TextStyle(fontSize: 12, color: fontColor),
                )
              : FlatButton(
                  onPressed: () async {
                    var url = request.auctionLinkEbay.toString();
                    if (await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Ebay - Naciśnij, aby przejść do aukcji",
                    style: TextStyle(fontSize: 12, color: fontColor),
                  ),
                ),
          Row(
            children: <Widget>[
              request.status == "ACTIVE"
                  ? FlatButton(
                      onPressed: () {
                        changeRequestStatus(request.requestId, "CANCELED");
                      },
                      child: Text(
                        "Anuluj",
                        style: TextStyle(fontSize: 12, color: fontColor),
                      ),
                    )
                  : Text(''),
              request.status == "CANCELED"
                  ? FlatButton(
                      onPressed: () {
                        changeRequestStatus(request.requestId, "ACTIVE");
                      },
                      child: Text(
                        "Wznów",
                        style: TextStyle(fontSize: 12, color: fontColor),
                      ),
                    )
                  : Text(''),
              FlatButton(
                onPressed: () {
                  deleteRequest(request.requestId);
                },
                child: Text(
                  "Usuń aukcję",
                  style: TextStyle(fontSize: 12, color: fontColor),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _CurrentRequestsState extends State<CurrentRequests> {
  List<Request> _requests;
  bool dataIsLoaded = false;
  String username;
  SharedPreferences user;
  int userid;
  String password;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// Funkcja do obsługi wciśnięcia przez użytkownika wyjścia z aplikacji.
  /// Sprawdza czy użytkownik całkowicie chce zamknąć aplikację.
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Czy chcesz zamknąć aplikację?"),
        actions: <Widget>[
          FlatButton(
            child: Text('Tak'),
            onPressed: () => SystemNavigator.pop(),
          ),
          FlatButton(
            child: Text('Nie'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }

  /// Funkcja wczytuje dane użytkownika, które zostały podane podczas logowania/rejestracji.
  Future loadUser() async {
    final SharedPreferences user = await SharedPreferences.getInstance();
    if (user.getString('username') != null) {
      setState(() {
        userid = user.getInt('userid');
        username = user.getString("username");
        password = user.getString('password');
        dataIsLoaded = true;
      });
    }
  }

  /// Funkcja, która pobiera wszystkie aktywne zapytania, które użytkownik dodał od aplikacji.
  /// Zwraca listę zapytań.
  Future<List<Request>> fetchRequestsActive() async {
    List<Request> requests = [];
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
        "https://fast-everglades-04594.herokuapp.com/request/user/$userid",
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body.toString());
      if (values.length > 0) {
        for (var a in values)
          if (a != null) {
            Request post = Request.fromJson(a);
            if (post.status == "ACTIVE") requests.add(post);
          }
      }
      return requests.reversed.toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  /// Funkcja, która pobiera wszystkie zakończone oraz przerwane zapytania, które użytkownik dodał od aplikacji.
  /// Zwraca listę zapytań.
  Future<List<Request>> fetchRequestsClosed() async {
    List<Request> requests = [];
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
        "https://fast-everglades-04594.herokuapp.com/request/user/$userid",
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body.toString());
      if (values.length > 0) {
        for (var a in values)
          if (a != null) {
            Request post = Request.fromJson(a);
            if (post.status == "CLOSED" || post.status == "CANCELED")
              requests.add(post);
          }
      }
      return requests.reversed.toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(
          key: Key("RequestsFloatingActionButton"),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: fontColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewRequestPage()),
            );
          },
        ),
        body: !dataIsLoaded
            ? Center(child: CircularProgressIndicator())
            : PageView(
                children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          ClipPath(
                            clipper: CustomShapeClipper(),
                            child: Container(
                              color: primaryBlue,
                              height: 250,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.refresh,
                                              color: Colors.white),
                                          onPressed: () {
                                            setState(() {});
                                          },
                                        ),
                                        Spacer(),
                                        Text(
                                          'Hunto',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          key: Key("LogoutUserButton"),
                                          icon: Icon(Icons.exit_to_app,
                                              color: Colors.white),
                                          onPressed: () {
                                            if (username != null) clearUser();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MyHomePage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                        ),
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Witaj,",
                                        style: TextStyle(
                                            fontSize: 32, color: Colors.white),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "$username",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Sprawdź swoje aktualne zapytania poniżej",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "Przesuń palcem w prawo, aby zobaczyć archiwum aukcji",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text('Twoje aktualne zapytania'),
                          Expanded(
                            child: FutureBuilder(
                              future: fetchRequestsActive(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data != null) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var x = snapshot.data[index];
                                      return buildItemCard(x);
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      child: Text(
                                        "Naciśnij + w prawym dolnym rogu",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Stack(children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          ClipPath(
                            clipper: CustomShapeClipper(),
                            child: Container(
                              color: archiveColor,
                              height: 250,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.refresh,
                                              color: Colors.white),
                                          onPressed: () {
                                            setState(() {});
                                          },
                                        ),
                                        Spacer(),
                                        Text(
                                          'Hunto',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          key: Key("LogoutUserButton"),
                                          icon: Icon(Icons.exit_to_app,
                                              color: Colors.white),
                                          onPressed: () {
                                            if (username != null) clearUser();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MyHomePage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                        ),
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Witaj,",
                                        style: TextStyle(
                                            fontSize: 32, color: Colors.white),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "$username",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Sprawdź swoje archiwalne zapytania poniżej",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text('Twoje archiwalne zapytania'),
                          Expanded(
                            child: FutureBuilder(
                              future: fetchRequestsClosed(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data != null) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var x = snapshot.data[index];
                                      return buildItemCard(x);
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      child: Text(
                                        "Naciśnij + w prawym dolnym rogu",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
      ),
    );
  }
}
