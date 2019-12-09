import 'dart:io';

import 'package:http/http.dart' show Client;
import '../User.dart';
import 'dart:convert';

class ApiProvider {
  static String username = "user";
  static String password = "user";
  Client client = Client();
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  fetchUser() async {
    final response = await client.get(
        "https://fast-everglades-04594.herokuapp.com/login",
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    User itemModel = User.fromJson(json.decode(response.body));
    return itemModel;
  }
}
