import 'package:flutter/material.dart';
import 'package:bmi/my_home_page.dart';
import 'package:bmi/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String _jwt = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _jwt.isEmpty ? const LoginPage() : const MyHomePage());
  }
}
