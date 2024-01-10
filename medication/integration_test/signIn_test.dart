import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medication/firebase_options.dart';
import 'package:medication/screens/signIn_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  testWidgets('SignIn widgets test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignInView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Zaloguj się"), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text("Podaj email"), findsOneWidget);
    expect(find.text("Podaj hasło"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text("Zaloguj"), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.text("Brak konta? Zarejestruj się!"), findsOneWidget);

    final Finder logInButton = find.byKey(const Key('logInButton'));
    final Finder emailField = find.byKey(const Key('emailField'));
    final Finder passwordField = find.byKey(const Key('passwordField'));

    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 1));
    expect(find.text("Pole nie może być puste!"), findsNWidgets(2));

    await tester.enterText(emailField, "a");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.enterText(passwordField, "a");
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 1));
    expect(find.text("Pole nie może być puste!"), findsNothing);
    expect(find.text("Niepoprawna forma adresu email"), findsOneWidget);

    await tester.tap(emailField);
    await Future.delayed(const Duration(seconds: 1));
    await tester.enterText(emailField, "new@op.pl");
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();
    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 1));
    expect(find.text("Niepoprawna forma adresu email"), findsNothing);

    expect(tester.widget<TextField>(find.byType(TextField).last).obscureText, isTrue);

    expect(find.byIcon(Icons.visibility), findsOneWidget);
    tester.tap(find.byIcon(Icons.visibility));
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(find.byType(TextField).last).obscureText, isFalse);

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    tester.tap(find.byIcon(Icons.visibility_off));
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(find.byType(TextField).last).obscureText, isTrue);
  });

  testWidgets('SignIn widgets test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignInView(),
      ),
    );
    await tester.pumpAndSettle();

    final Finder logInButton = find.byKey(const Key('logInButton'));
    final Finder emailField = find.byKey(const Key('emailField'));
    final Finder passwordField = find.byKey(const Key('passwordField'));

    await tester.enterText(emailField, "aa@op.pl");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.enterText(passwordField, "aa");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    User? user = FirebaseAuth.instance.currentUser;
    expect(user, null);

    await tester.pumpAndSettle();
    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 1));

    await tester.tap(emailField);
    await Future.delayed(const Duration(seconds: 1));
    await tester.enterText(emailField, "dorokow599@student.polsl.pl");
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.tap(passwordField);
    await Future.delayed(const Duration(seconds: 1));
    await tester.enterText(passwordField, "aa");
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();
    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 1));
    user = FirebaseAuth.instance.currentUser;
    expect(user, null);

    await tester.tap(passwordField);
    await Future.delayed(const Duration(seconds: 1));
    await tester.enterText(passwordField, "haslo123");
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();
    await tester.tap(logInButton);
    await Future.delayed(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    user = FirebaseAuth.instance.currentUser;
    expect(user, isNotNull);
  });
}