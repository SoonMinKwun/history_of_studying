import 'package:flutter/material.dart';

// 빌더를 전달받음
class WeatherScreen extends StatefulWidget {
  WeatherScreen({this.parseWeatherData}); // 생성자 선언
  final dynamic parseWeatherData;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

// 날씨를 텍스트로 표시하는 부분
class _WeatherScreenState extends State<WeatherScreen> {
  late String cityName; // 도시명
  late int temp; // 온도

  @override
  void initState() {
    // 부모 StatefulWidget(WeatherScreen)에서 parseWeatherData를 받아서 쓸 수 있음!
    super.initState();
    updateData(widget.parseWeatherData);
  }

  // 날씨 업데이트
  void updateData(dynamic weatherData) {
    double temp2 = weatherData['main']['temp'];
    temp = temp2.round(); // 반올림
    cityName = weatherData['name'];

    print(temp);
    print(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$cityName',
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '$temp',
                style: TextStyle(fontSize: 30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
