import 'dart:convert';
import 'dart:io';

import 'package:auction_search/User.dart';
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//TODO:
// - dodac ze nie mozna zostawic pustego pola
// - zmienic onChange na onSaved poprzez dodanie formKey
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
    print(response.statusCode);
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

  Form buildDescriptionTextField() {
    return Form(
      key: _formKeyDescription,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _textDescription,
        autocorrect: false,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Tytuł aukcji',
            fillColor: Colors.black,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _textDescription.clear();
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'To pole nie może być puste';
          }
        },
        // onChanged: (value) => _description = value,
      ),
    );
  }

  Form buildPriceTextField() {
    return Form(
      key: _formKeyPrice,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _textPrice,
        autocorrect: false,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Cena',
            fillColor: Colors.black,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _textPrice.clear();
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'To pole nie może być puste';
          }
        },
        // onChanged: (value) => _price = double.parse(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Dodaj nowe zapytanie"),
        centerTitle: true,
      ),
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              child: Text("Dodaj zapytanie"),
              onPressed: () {
                setState(() {
                  if (_formKeyPrice.currentState.validate()) {
                    this._price = double.parse(_textPrice.text);
                  }
                  if (_formKeyDescription.currentState.validate()) {
                    this._description = _textDescription.text;
                  }
                });
                print(_price);
                print(_description);
                addNewRequest(_description, _price);
              },
            ),
          ],
        ),
      ),
    );
  }
}
