import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/loginPage.dart';
import 'package:auction_search/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Auction Search',
        theme: ThemeData(
            primarySwatch: Colors.grey,
            fontFamily: "Montserrat",
            backgroundColor: Colors.grey),
        home: FutureBuilder<bool>(
          future: showLoginPage(),
          builder: (context, snapshot) {
            if (snapshot.hasData == true) {
              if (snapshot.data) {
                return CurrentRequests();
              } else {
                return MyHomePage(title: 'Main Screen');
              }
            } else {
              return MyHomePage(
                title: 'Main Screen',
              );
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<bool> showLoginPage() async {
  var userLogged = await SharedPreferences.getInstance();
  String user = userLogged.getString('username');
  if (user == null) {
    return false;
  }
  return true;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Witaj w',
                style: TextStyle(fontSize: 30),
              ),
              Text('Auction Search',
                  style: TextStyle(fontSize: 45, color: Colors.black)),
              Padding(
                padding: EdgeInsets.only(top: 200),
              ),
              FlatButton(
                child: Text(
                  'Zaloguj się',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              FlatButton(
                child: Text(
                  'Zarejestruj się',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
            ]),
      ),
    );
  }
}
