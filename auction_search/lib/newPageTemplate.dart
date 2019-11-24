import 'package:flutter/material.dart';

class $NAME$ extends StatefulWidget {
  $NAME$({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _$NAME$State createState() => new _$NAME$State();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   $NAME$.routeName: (BuildContext context) => new $NAME$(title: "$NAME$"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, $NAME$.routeName);
///

class _$NAME$State extends State<$NAME$> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(),
    );
  }
}