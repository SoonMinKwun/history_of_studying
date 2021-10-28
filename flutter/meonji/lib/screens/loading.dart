// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState(); // 상태초기화 1회만 실행
    getLocation(); // 위치 정보 가져오기
    fetchData();
  }

  void getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          // 위치 정보를 position에 삽입
          desiredAccuracy: LocationAccuracy.high); // 위치 정확도
      print(position);
    } catch (e) {
      print('인터넷 연결에 문제가 생겼습니다!');
    }
  }

  void fetchData() async {
    // uri 파싱
    http.Response response = await http.get(Uri.parse(
        'https://samples.openweathermap.org/data/2.5/weather?q=London&appid=b1b15e88fa797225412429c1c50c122a1'));
    // api 호출 성공 시
    if (response.statusCode == 200) {
      String jsonData = response.body; // 바디부분 추출
      var myJson = jsonDecode(jsonData)['weather'][0]['description'];
      // 디코드 과정, api 호출 시 어떤 형태의 데이터가 올지 모름...
      //그래서 변수 타입은 var, jsonDecode는 dynamic 타입을 받음
      print(myJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black, // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {},
        child: Text('Get my location'),
      )),
    );
  }
}
