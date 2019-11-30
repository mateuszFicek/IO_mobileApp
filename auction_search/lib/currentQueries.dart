import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'request.dart';

class CurrentQueries extends StatefulWidget {
  CurrentQueries({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CurrentQueriesState createState() => new _CurrentQueriesState();
}

class FakeQueryData {
  static String name = "Samsung Galaxy S10";
  static int price = 1000;
  static String auctionService = "Allegro.pl";
}

class _CurrentQueriesState extends State<CurrentQueries> {
  List<Request> _requests;
  bool dataIsLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchPost();
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
        body: !dataIsLoaded
            ? Center(child: CircularProgressIndicator())
            : new Center(
                child: Column(
                  children: <Widget>[
                    Text('Your current queries!'),
                  ],
                ),
              ),
      ),
    );
  }
}
