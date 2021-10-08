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

  String _bmi = '0';

  // 0: 대기, 1: 저체중, 2: 정상, 3: 과체중, 4: 비만, 5:고도비만만
  int _bmiStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("BMI 계산기"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _hController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '키(cm)',
                ),
                validator: (String? value) {
                  // == null || isEmpty => !.isEmpty
                  if (value!.isEmpty) {
                    return '키를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _wController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '몸무게(kg)',
                ),
                validator: (String? value) {
                  // == null || isEmpty => !.isEmpty
                  if (value!.isEmpty) {
                    return '몸무게를 입력해주세요';
                  }
                  return null;
                },
              ),
              Container(
                height: 70,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double h = double.parse(_hController.text);
                      double w = double.parse(_wController.text);
                      double bmiDouble = h / ((w / 100) * (w / 100));
                      String bmi = (bmiDouble).toStringAsFixed(2);

                      int bmiStatus = 0;

                      if (bmiDouble < 1.85) {
                        bmiStatus = 1;
                        bmi = '저체중($bmi)';
                      } else if (bmiDouble >= 1.85 && bmiDouble < 23) {
                        bmiStatus = 2;
                        bmi = '정상($bmi)';
                      } else if (bmiDouble >= 23 && bmiDouble < 25) {
                        bmiStatus = 4;
                        bmi = '과체중($bmi)';
                      } else if (bmiDouble >= 25 && bmiDouble < 30) {
                        bmiStatus = 5;
                        bmi = '비만($bmi)';
                      } else if (bmiDouble >= 30) {
                        bmiStatus = 6;
                        bmi = '고도비만($bmi)';
                      }

                      setState(() {
                        _bmi = bmi;
                        _bmiStatus = bmiStatus;
                      });
                    }
                  },
                  child: const Text('BMI 계산하기'),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  "BMI : $_bmi",
                  style: const TextStyle(fontSize: 25.0),
                ),
              ),
              const SizedBox(height: 20.0),
              Image(
                width: 200.0,
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
                                    : 'assets/images/5.png'),
              ),
            ],
          ),
        ),
      ),
      /*
      bottomNavigationBar: Container(
        //height: 50,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('BMI 계산하기'),
        ),
      ),
      */
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }
}
