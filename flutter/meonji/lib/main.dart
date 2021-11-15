// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:meonji/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // firebase를 사용할거야~ 라는 의미 (초기화 메서드)
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '먼지어때?',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      // home: Loading(),
      home: LoginSignupScreen(),
    );
  }
}
