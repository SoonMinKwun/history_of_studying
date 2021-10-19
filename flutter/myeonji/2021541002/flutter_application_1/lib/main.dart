// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'my_home_page.dart';
import 'login_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  String _jwt = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _jwt.isEmpty ? const LoginPage() : const MyHomePage(),
    );
  }

  @override
  initState() {
    super.initState();
    _initDB();
  }

  @override
  dispose() async {
    super.dispose();
  }

  _initDB() async {
    if (box.read('jwt') == null) {
      box.write('jwt', '');
    }
  }

  _getJWT() {
    setState(() {
      _jwt = box.read('jwt');
    });

    box.listenKey('jwt', (value) {
      setState(() {
        _jwt = value;
      });
    });
  }
}
