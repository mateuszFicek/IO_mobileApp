import 'dart:developer';
import 'dart:io';

import 'package:auction_search/addNewRequestPage.dart';
import 'package:auction_search/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'request.dart';

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
    fetchRequests();
  }

  Future clearUser() async {
    final SharedPreferences user = await SharedPreferences.getInstance();
    user.clear();
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

  Future fetchRequests() async {
    List<Request> requests = [];
    final SharedPreferences user = await SharedPreferences.getInstance();

    username = user.getString('username');
    print("USERID $userid");
    String password = user.getString('password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
        "https://fast-everglades-04594.herokuapp.com/request/user/$userid",
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      print("Body = ");
      print(response.body);
      values = json.decode(response.body);
      if (values.length > 0) {
        for (var a in values)
          if (a != null) {
            Request post = Request.fromJson(a);
            requests.add(post);
          }
      }
    } else {
      throw Exception('Failed to load post');
    }
    setState(() {
      _requests = requests;
      dataIsLoaded = true;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you really want to close the app?"),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () => SystemNavigator.pop(),
          ),
          FlatButton(
            child: Text('No'),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            "Hello",
                            style: TextStyle(fontSize: 32),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          Text(
                            "$username",
                            style: TextStyle(fontSize: 48),
                          ),
                        ]),
                    FlatButton(
                      onPressed: () {
                        if (username == null) clearUser();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MyHomePage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text("Logout"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
