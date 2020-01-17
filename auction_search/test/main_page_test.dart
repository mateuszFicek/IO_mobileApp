/*Copyright (c) 2020, Michał Kilian, Mateusz Gujda, Mateusz Ficek
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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
