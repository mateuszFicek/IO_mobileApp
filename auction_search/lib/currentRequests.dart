import 'dart:developer';
import 'dart:io';

import 'package:auction_search/addNewRequestPage.dart';
import 'package:auction_search/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auction_search/request.dart';

// TODO:
// - usuwanie zapytań
// - edycja zapytań
// - podgląd zapytania

class CurrentRequests extends StatefulWidget {
  CurrentRequests({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CurrentRequestsState createState() => new _CurrentRequestsState();
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

  Future clearUser() async {
    final SharedPreferences user = await SharedPreferences.getInstance();
    user.clear();
  }

  Card buildItemCard(Request request) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Opis: ${request.description}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Cena: ${request.price.toString()}',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              'Status: ${request.status.toString()}',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

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

  Future<List<Request>> fetchRequests() async {
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
            requests.add(post);
          }
      }
      return requests;
    } else {
      throw Exception('Failed to load post');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.grey,
          ),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewRequestPage()),
            );
          },
        ),
        body: !dataIsLoaded
            ? Center(child: CircularProgressIndicator())
            : new Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(25),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  "Witaj",
                                  style: TextStyle(fontSize: 32),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                ),
                                Text(
                                  "$username",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                          FlatButton(
                            onPressed: () {
                              if (username != null) clearUser();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyHomePage()),
                                  (Route<dynamic> route) => false);
                            },
                            child: Text("Wyloguj się"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: fetchRequests(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
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
      ),
    );
  }
}
