import 'package:flutter/material.dart';
import 'package:first_val_product/main_page.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(primaryColor: Colors.white70),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage(),
        },
      ),
    );
