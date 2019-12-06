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
  int user;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    //fetchPost();
    _loadUser();
  }

  _loadUser() async {
    print("Loading user data");
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = (prefs.getInt('userid'));
      dataIsLoaded = true;
    });
  }

//DODAC LINK DO POBIERANIA DANYCH Z NASZEGO SERWERA
  Future<Request> fetchPost() async {
    List<Request> requests = [];
    //ZMIENIC TU LINK
    final response =
        await http.get('http://www.mocky.io/v2/5de24d79320000afe88095b6');
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (var a in values)
          if (a != null) {
            Request post = Request.fromJson(a);
            requests.add(post);
          }
        print(requests.length.toString());
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
          child: Icon(Icons.add),
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
                    Text('Here is your home page! You are user: $user'),
                    FlatButton(
                      onPressed: () {
                        prefs.clear();
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
