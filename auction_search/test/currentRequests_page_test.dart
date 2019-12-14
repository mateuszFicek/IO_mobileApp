import 'dart:convert';
import 'package:auction_search/addNewRequestPage.dart';
import 'package:auction_search/currentRequests.dart';
import 'package:auction_search/main.dart';
import 'package:auction_search/registerPage.dart';
import 'package:mockito/mockito.dart';
import 'package:auction_search/resources/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      home: CurrentRequests(),
      navigatorObservers: [mockObserver],
    ));
    verify(mockObserver.didPush(any, any));
  }

  Future<Null> _navigateToNewRequestPagePage(WidgetTester tester) async {
    await tester.tap(find.byKey(Key("RequestsFloatingActionButton")));
    await tester.pumpAndSettle();
  }

  testWidgets('Going to AddNewRequest page', (WidgetTester tester) async {
    await _buildMainPage(tester);
    await _navigateToNewRequestPagePage(tester);

    verify(mockObserver.didPush(any, any));
    expect(find.byType(AddNewRequestPage), findsOneWidget);
    print("Przejście do strony dodawania nowego zapytania.");
  });
}
