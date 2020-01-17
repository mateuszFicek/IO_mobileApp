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
