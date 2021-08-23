import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyButtons(),
    );
  }
}

class MyButtons extends StatelessWidget {
  const MyButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buttons'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  print('text button1');
                },
                onLongPress: () {
                  print('text button2');
                },
                child: Text(
                  'Text button',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: TextButton.styleFrom(
                    primary: Colors.red, backgroundColor: Colors.blue)),
            ElevatedButton(
              onPressed: null,
              child: Text('Elevated button'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0.0,
                  onSurface: Colors.pink),
            ),
            OutlinedButton(
              onPressed: () {
                print('Outlined button');
              },
              child: Text('Outlined button'),
              style: OutlinedButton.styleFrom(
                  primary: Colors.green,
                  side: BorderSide(color: Colors.black87, width: 2.0),
                  minimumSize: Size(200, 50)),
            ),
            TextButton.icon(
              onPressed: () {
                print('Icon button');
              },
              icon: Icon(
                Icons.home,
                size: 30.0,
                // color: Colors.black87,
              ),
              label: Text('Go to home!'),
              style: TextButton.styleFrom(
                  primary: Colors.purple, minimumSize: Size(200, 50)),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: EdgeInsets.all(20.0),
              children: [
                TextButton(onPressed: () {}, child: Text('1')),
                ElevatedButton(onPressed: () {}, child: Text('2'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
