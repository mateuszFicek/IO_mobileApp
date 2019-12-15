import 'dart:convert';
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/registerPage.dart';
import 'package:mockito/mockito.dart';
import 'package:auction_search/resources/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auction_search/main.dart';
import 'package:auction_search/loginPage.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  NavigatorObserver mockObserver;
  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<Null> _buildMainPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(),
      navigatorObservers: [mockObserver],
    ));
    verify(mockObserver.didPush(any, any));
  }

  Future<Null> _navigateToLoginPage(WidgetTester tester) async {
    await tester.tap(find.byKey(Key('loginFromMainPageKey')));
    await tester.pumpAndSettle();
  }

  testWidgets('Going to login page', (WidgetTester tester) async {
    await _buildMainPage(tester);
    await _navigateToLoginPage(tester);

    verify(mockObserver.didPush(any, any));
    expect(find.byType(LoginPage), findsOneWidget);
    print('Przechodzenie na stronę z logowaniem.');
  });

  test('Test SharedPreferences setup', () async {
    SharedPreferences.setMockInitialValues(({'username': 'user'}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('username');
    expect(user, 'user');
    print("Zapisywanie danych użytkownika w pamięci telefonu.");
  });

  test('Test SharedPreferences setup', () async {
    SharedPreferences.setMockInitialValues(({'username': 'user'}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('username');
    bool s;
    await showLoginPage().then((value) {
      s = value;
    });
    expect(s, true);
    print("Sprawdzanie czy użytkownik jest zalogowany na urządzeniu");
  });
}
