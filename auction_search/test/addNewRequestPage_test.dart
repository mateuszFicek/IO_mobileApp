import 'dart:convert';
import 'package:auction_search/addNewRequestPage.dart';
import 'package:auction_search/registerPage.dart';
import 'package:mockito/mockito.dart';
import 'package:auction_search/resources/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auction_search/loginPage.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  testWidgets('Finding widgets on page', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    await tester.pumpWidget(buildTestableWidget(AddNewRequestPage()));
    expect(find.byKey(Key('BackIcon')), findsOneWidget);
    expect(find.byKey(Key('AddRequestButton')), findsOneWidget);
    print('Znajdowanie ikon na stronie dodawania zapytania.');
  });
  testWidgets('Finding text on page', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    await tester.pumpWidget(buildTestableWidget(AddNewRequestPage()));
    expect(find.text('Dodaj nowe zapytanie'), findsOneWidget);
    expect(find.text("Wpisz tytuł aukcji oraz podaj cenę przedmiotu"),
        findsOneWidget);
    expect(find.text("Dodaj zapytanie"), findsOneWidget);
    print('Znajdowanie tekstów na stronie dodawania zapytania.');
  });
}
