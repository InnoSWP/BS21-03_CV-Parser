import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cv_parser/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDDTmdBfJ8wzjAzUhsobX8vTNC1-eK0OGE",
      appId: "1:103125616835:web:829cea0dc34e91cf9b7a76",
      messagingSenderId: "103125616835",
      projectId: "cv-parser-265d0",
    ),
  );

  runApp(
    MaterialApp(
      theme: ThemeData(primaryColor: Colors.white70),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
      },
    ),
  );
}
