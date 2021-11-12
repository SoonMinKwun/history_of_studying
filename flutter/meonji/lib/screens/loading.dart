// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:meonji/data/my_location.dart'; // 위치정보관련
import 'package:meonji/data/network.dart'; // 날씨데이터 관련
import 'package:meonji/api/key.dart'; // API Key
import 'package:meonji/screens/weather_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart'; // 로딩 화면 관련
import 'package:page_transition/page_transition.dart'; // 로딩 화면 관련

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late double latitude3; // 위도 변수 선언
  late double longitude3; // 경도 변수 선언

  @override
  void initState() {
    super.initState(); // 상태초기화 1회만 실행
    getLocation(); // 위치 정보 가져오기
  }

  void getLocation() async {
    Mylocation myLocation = Mylocation();
    await myLocation.getMyCurrentLocation();
    latitude3 = myLocation.latitude2; // 위도 변수 삽입
    longitude3 = myLocation.longitude2; // 경도 변수 삽입
    print(latitude3);
    print(longitude3);

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude3&lon=$longitude3&appid=$apiKey&units=metric',
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude3&lon=$longitude3&appid=$apiKey');

    var weatherData = await network.getJsonData(); // api값을 그릇에 담기 (날씨 정보)
    print(weatherData);

    var airData = await network.getAirData(); // api값을 그릇에 담기 (미세먼지 정보)
    print(airData);

    // weather_screen으로 빌더를 넘기고 weatherData값 전달해서 라우트
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WeatherScreen(
          parseWeatherData: weatherData, parseAirPollution: airData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset(
              'image/logo.png',
              width: 300.0,
              height: 300.0,
            ),
            nextScreen: WeatherScreen(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.white));
  }
}
