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
// - zmienić wygląd i napisy, ktore pojawiaja sie
// - dodac ze nie mozna zostawic pustego pola
class AddNewRequestPage extends StatefulWidget {
  AddNewRequestPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddNewRequestPageState createState() => new _AddNewRequestPageState();
}

class _AddNewRequestPageState extends State<AddNewRequestPage> {
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
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var params = {
      "userid": userid,
      "max_price": price,
      "descripition": description
    };
    var jsonResponse;
    var response = await http.post(
        "https://fast-everglades-04594.herokuapp.com/request/add",
        body: json.encode(params),
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "Accept": "application/json",
          "content-type": "application/json"
        });
    if (response.statusCode == 200) {
      print("Body requesta = ");
      print(response.body);
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      print("Udało się!");
      Request currentRequest = Request.fromJson(jsonResponse);
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
        title: Text("Request was added"),
        actions: <Widget>[
          FlatButton(
            child: Text('Go back to all requests'),
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

  TextFormField buildDescriptionTextField() {
    return TextFormField(
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
            icon: Icon(Icons.clear, color: Colors.black),
            onPressed: () {},
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some task';
        }
      },
      onChanged: (value) => _description = value,
    );
  }

  TextFormField buildPriceTextField() {
    return TextFormField(
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
            icon: Icon(Icons.clear, color: Colors.black),
            onPressed: () {},
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some task';
        }
      },
      onChanged: (value) => _price = double.parse(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
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
                //Dodać funkcję do wysyłania requestów do serwera
                print(_price.toString());
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
