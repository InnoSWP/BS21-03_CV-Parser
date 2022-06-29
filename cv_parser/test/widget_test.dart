// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cv_parser/main.dart';

void main() {
  String testCV = """
    My Name
    +78901234567 | @Alias | email@gmail.com

    SKILLS
    Technical: skill1, skill2, skill3, skill4
    Soft Skills: skill1, skill2, skill3, skill4
    Languages: language1, language2, language3, language4

    EDUCATION
    e1
    e2
    e3

    PROFESSIONAL EXPERIENCE
    pe1
    pe2
    pe3

    INSTRUCTING EXPERIENCE
    ie1
    ie2
    ie3

    PROJECTS
    p1
    p2
    p3

    DEVELOPMENT
    d1
    d2
    d3
    """;
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    //await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
