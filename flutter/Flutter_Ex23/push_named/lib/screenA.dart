// ignore_for_file: file_names, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';

class ScreenA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen A'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/B');
              },
              color: Colors.red,
              child: Text('Go to Screen B'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/C');
              },
              color: Colors.red,
              child: Text('Go to Screen C'),
            )
          ],
        ),
      ),
    );
  }
}
