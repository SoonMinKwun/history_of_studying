import 'package:flutter/material.dart';
import 'package:push_named/ScreenB.dart';
import 'package:push_named/ScreenC.dart';
import 'screenA.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ScreenA(),
        '/B': (context) => ScreenB(),
        '/C': (context) => ScreenC(),
      },
    );
  }
}
