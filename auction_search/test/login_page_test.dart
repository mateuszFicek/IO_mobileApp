import 'dart:convert';
import 'package:auction_search/registerPage.dart';
import 'package:mockito/mockito.dart';
import 'package:auction_search/resources/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auction_search/loginPage.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  NavigatorObserver mockObserver;
  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<Null> _buildMainPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
      navigatorObservers: [mockObserver],
    ));
    verify(mockObserver.didPush(any, any));
  }

  testWidgets('Finding widgets on Login page', (WidgetTester tester) async {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    await tester.pumpWidget(buildTestableWidget(LoginPage()));
    expect(find.byKey(Key("LoginTextField")), findsOneWidget);
    expect(find.byKey(Key("PasswordTextField")), findsOneWidget);
    expect(find.byKey(Key("navigateToRegisterPage")), findsOneWidget);
    print('Znajdowanie widgetów na stronie logowania.');
  });

  testWidgets('Testing server response', (WidgetTester tester) async {
    final apiProvider = ApiProvider();
    apiProvider.client = MockClient((request) async {
      final mapJson = {'username': "user", "password": "user"};
      return Response(json.encode(mapJson), 200);
    });
    final item = await apiProvider.fetchUser();
    expect(item.username, "user");
    print('Testowanie odpowiedzi serwera.');
  });
}
