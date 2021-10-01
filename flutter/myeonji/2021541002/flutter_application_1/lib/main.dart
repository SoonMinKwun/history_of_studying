// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController hController = TextEditingController();
  TextEditingController wController = TextEditingController();

  double h = 0;
  double w = 0;
  double bmi = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BMI 계산기"),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Center(
              child: Text(
                "BMI : ${bmi.toStringAsFixed(3)}",
                style: TextStyle(fontSize: 35.0),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  child: TextField(
                    controller: hController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "키"),
                    onChanged: (value) {
                      setState(() {
                        h = double.parse(value);
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  child: TextField(
                    controller: wController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "몸무게"),
                    onChanged: (value) {
                      setState(() {
                        w = double.parse(value);
                      });
                    },
                  ),
                ),
              )
            ]),
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  double _bmi = w / ((h / 100) * (h / 100));
                  setState(() {
                    bmi = _bmi;
                  });
                },
                child: Text("확인"),
              ),
            ),
          ]),
        ));
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }
}
