// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:meonji/data/my_location.dart'; // 위치정보관련
import 'package:meonji/data/network.dart'; // 날씨데이터 관련
import 'package:meonji/api/key.dart'; // API Key
import 'package:meonji/screens/weather_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 사용자 등록/인증 관련

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late double latitude3; // 위도 변수 선언
  late double longitude3; // 경도 변수 선언
  final _authentification =
      FirebaseAuth.instance; // firebase auth 인스턴스 생성 (변하지 않는 private)
  User? loggedUser; // 로그인된 유저

  // 유저 정보 불러오기
  void getCurrentUser() {
    try {
      final user =
          _authentification.currentUser; // _authentification에서 가져온 유저 이름을 삽입
      // 로그인 성공시
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
      // 로그인 실패시
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState(); // 상태초기화 1회만 실행
    getLocation(); // 위치 정보 가져오기
    getCurrentUser(); // 초기화 될때마다 유저 정보 불러오기
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
    return CircularProgressIndicator(); // 로딩화면
  }
}
