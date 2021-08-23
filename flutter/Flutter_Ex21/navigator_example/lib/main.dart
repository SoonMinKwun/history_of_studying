// ignore_for_file: prefer_const_constructors, empty_statements, dead_code, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Page',
      theme: ThemeData(primarySwatch: Colors.red),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context1, MaterialPageRoute(builder: (_) => SecondPage()));
          },
          child: Text('Go to the Second page!'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context2);
          },
          child: Text('Go to the First page!'),
        ),
      ),
    );
  }
}
