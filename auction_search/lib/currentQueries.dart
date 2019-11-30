import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        body: new Center(
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
