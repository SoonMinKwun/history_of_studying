// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _wController = TextEditingController();

  double h = 0;
  double w = 0;
  double bmi = 0.0;
  String bmi_string = '';

  // 0: 대기, 1: 저체중, 2: 정상, 3: 과체중, 4: 비만, 5: 고도비만
  int _bmiStatus = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI 계산기"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            TextFormField(
              controller: _hController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "키(cm)",
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  // == null || isEmpty => !.isEmpty
                  return '키를 입력해주세요!';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  h = double.parse(value);
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _wController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "몸무게(kg)"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  // == null || isEmpty => !.isEmpty
                  return '몸무게를 입력해주세요!';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  w = double.parse(value);
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // print('키: ${_hController.text}, 몸무게: ${_wController.text}');
                    double _bmi = w / ((h / 100) * (h / 100));

                    int bmiStatus = 0;

                    if (bmi < 18.5) {
                      bmiStatus = 1;
                      bmi_string = '저체중';
                    } else if (bmi >= 18.5 && bmi < 23.0) {
                      bmiStatus = 2;
                      bmi_string = '정상';
                    } else if (bmi >= 23.0 && bmi < 25.0) {
                      bmiStatus = 3;
                      bmi_string = '과체중';
                    } else if (bmi >= 25.0 && bmi < 30.0) {
                      bmiStatus = 4;
                      bmi_string = '비만';
                    } else if (bmi >= 30.0) {
                      bmiStatus = 5;
                      bmi_string = '고도비만';
                    }
                    setState(() {
                      bmi = _bmi;
                      _bmiStatus = bmiStatus;
                    });
                  }
                },
                child: const Text("BMI 계산하기"),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                "BMI : ${bmi.toStringAsFixed(3)} (${bmi_string})",
                style: TextStyle(fontSize: 35.0),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Image(
                width: 200.0,
                height: 200.0,
                image: AssetImage(_bmiStatus == 0
                    ? 'assets/images/0.png'
                    : _bmiStatus == 1
                        ? 'assets/images/1.png'
                        : _bmiStatus == 2
                            ? 'assets/images/2.png'
                            : _bmiStatus == 3
                                ? 'assets/images/3.png'
                                : _bmiStatus == 4
                                    ? 'assets/images/4.png'
                                    : 'assets/images/5.png')),
          ]),
        ),
      ),
    );
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
