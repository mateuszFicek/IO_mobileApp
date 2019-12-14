import 'package:flutter/material.dart';

/// Klasa template, która umożliwia szybsze dodawanie nowych stron.
class $NAME$ extends StatefulWidget {
  $NAME$({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _$NAME$State createState() => new _$NAME$State();
}

class _$NAME$State extends State<$NAME$> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(),
    );
  }
}
