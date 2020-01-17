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
import 'package:auction_search/request.dart';
import 'package:auction_search/resources/CustomShapeClipper.dart';
import 'package:auction_search/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Strona do dodawania nowego zapytania.
/// Użytkownik proszony jest o podanie tytułu aukcji oraz ceny.
class AddNewRequestPage extends StatefulWidget {
  AddNewRequestPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddNewRequestPageState createState() => new _AddNewRequestPageState();
}

class _AddNewRequestPageState extends State<AddNewRequestPage> {
  var _formKeyPrice = GlobalKey<FormState>();
  var _formKeyDescription = GlobalKey<FormState>();

  String _description;
  double _price;
  TextEditingController _textDescription = new TextEditingController();
  TextEditingController _textPrice = new TextEditingController();
  bool _isLoading = false;
  bool validatedData = false;

  /// Funkcja, która wysyła przygotowane zapytanie na serwer.
  Future addNewRequest(String description, double price) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String username = user.getString('username');
    String password = user.getString('password');
    int userid = user.getInt('userid');
    final _authority = "fast-everglades-04594.herokuapp.com";
    final _path = "/request/add";
    final _params = {"userId": userid.toString()};
    final _uri = Uri.https(_authority, _path, _params);
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var params = {"maxPrice": price, "description": description};
    var jsonResponse;
    var response = await http.post(_uri, body: json.encode(params), headers: {
      HttpHeaders.authorizationHeader: basicAuth,
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      onRequestAdded();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Funkcja, która obsługuje aplikację po dodaniu zapytania.
  /// Po dodaniu zapytania użytkownik powraca do strony ze wszystkimi zapytaniami.
  Future<bool> onRequestAdded() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Dodano zapytanie"),
        actions: <Widget>[
          FlatButton(
            child: Text('Wróć do wszystkich zapytań'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => CurrentRequests()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  /// Formularz, który pobiera od użytkownika tytuł funkcji.
  Form buildDescriptionTextField() {
    return Form(
      key: _formKeyDescription,
      child: TextFormField(
        style: TextStyle(color: fontColor),
        controller: _textDescription,
        autocorrect: false,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cardBorderColor, width: 0.0),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: new BorderRadius.circular(25.0),
            ),
            hintText: 'Tytuł aukcji',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _textDescription.clear();
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'To pole nie może być puste';
          }
        },
      ),
    );
  }

  /// Formularz, który pobiera od użytkownika tytuł cenę.
  Form buildPriceTextField() {
    return Form(
      key: _formKeyPrice,
      child: TextFormField(
        style: TextStyle(color: fontColor),
        controller: _textPrice,
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
            hintText: 'Cena',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _textPrice.clear();
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'To pole nie może być puste';
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
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
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                IconButton(
                                  key: Key('BackIcon'),
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Spacer(),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Dodaj nowe zapytanie",
                                style: TextStyle(
                                    fontSize: 32, color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Wpisz tytuł aukcji oraz podaj cenę przedmiotu",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 250,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 120,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: buildDescriptionTextField(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: buildPriceTextField(),
                          ),
                          FlatButton(
                            key: Key('AddRequestButton'),
                            child: Text("Dodaj zapytanie"),
                            onPressed: () {
                              setState(() {
                                if (_formKeyPrice.currentState.validate() &&
                                    _formKeyDescription.currentState
                                        .validate()) {
                                  this._price = double.parse(_textPrice.text);
                                  this._description = _textDescription.text;
                                  validatedData = true;
                                }
                              });
                              if (validatedData)
                                addNewRequest(_description, _price);
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
