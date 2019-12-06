import 'package:flutter/material.dart';

//TODO:
// - zmienić wygląd i napisy, ktore pojawiaja sie
// - dodac ze nie mozna zostawic pustego pola
// - dodac wysylanie requestow na serwer
class AddNewRequestPage extends StatefulWidget {
  AddNewRequestPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddNewRequestPageState createState() => new _AddNewRequestPageState();
}

class _AddNewRequestPageState extends State<AddNewRequestPage> {
  String _description;
  TextEditingController _textDescription = new TextEditingController();
  double _price;
  TextEditingController _textPrice = new TextEditingController();
  TextFormField buildDescriptionTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _textDescription,
      autocorrect: false,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Description',
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
          hintText: 'Price',
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
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildDescriptionTextField(),
            buildPriceTextField(),
            FlatButton(
              child: Text("Submit request"),
              onPressed: () {
                //Dodać funkcję do wysyłania requestów do serwera
                print(_price.toString());
                print(_description);
              },
            ),
            Text("Add new request page."),
          ],
        ),
      ),
    );
  }
}
