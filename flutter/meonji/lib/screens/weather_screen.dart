// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 폰트
import 'package:flutter_svg/flutter_svg.dart'; // svg 사용하기 위함
import 'package:http/http.dart'; // http 연결 관련
import 'package:intl/intl.dart'; // DateTime Format
import 'package:meonji/screens/login.dart';
import 'package:timer_builder/timer_builder.dart'; // 시스템 시간 불러오기 위함
import 'package:meonji/model/model.dart'; // condition에 따른 svg 표시 조건문
import 'package:meonji/data/my_location.dart'; // 위치정보관련
import 'package:meonji/data/network.dart'; // 날씨데이터 관련
import 'package:meonji/api/key.dart'; // API Key
import 'package:meonji/screens/search.dart'; // 위치 검색 페이지
import 'dart:io'; // sleep 기능 관련
import 'package:firebase_auth/firebase_auth.dart'; // 사용자 등록/인증 관련
import 'package:firebase_core/firebase_core.dart'; // firebase_core
import 'package:firebase_database/firebase_database.dart'; // realtime database 관련

// 빌더를 전달받음
class WeatherScreen extends StatefulWidget {
  WeatherScreen({this.parseWeatherData, this.parseAirPollution}); // 생성자 선언
  dynamic parseWeatherData; // 생성자 선언을 위한 날씨 정보 파싱
  dynamic parseAirPollution; // 생성자 선언을 위한 미세먼지 정보 파싱

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

// 날씨를 텍스트로 표시하는 부분
class _WeatherScreenState extends State<WeatherScreen> {
  late String cityName; // 도시명
  late int temp; // 온도
  late Widget icon; // 날씨 아이콘
  late String des; // 날씨 설명
  late Widget airIcon; // 미세먼지 아이콘
  late Widget airState; // 미세먼지 설명
  var date = DateTime.now(); // 오늘 날짜
  late double pm10; // 미세먼지 (PM10)
  late double pm2_5; // 초미세먼지 (PM2.5)
  final _authentification =
      FirebaseAuth.instance; // firebase auth 인스턴스 생성 (변하지 않는 private)
  User? loggedUser; // 로그인된 유저
  late double currentLatitude; // 최근 위도 변수 선언
  late double currentLongitude; // 최근 경도 변수 선언
  double? rasPM_10; // 라즈베리파이 미세먼지 10㎍/m³짜리 측정 값
  double? rasPM_25; // 라즈베리파이 미세먼지 2.5㎍/m³짜리 측정 값
  late String rasPM_date; // 라즈베리파이 미세먼지 최근 측정 날짜

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
    // 부모 StatefulWidget(WeatherScreen)에서 parseWeatherData를 받아서 쓸 수 있음!
    super.initState();
    updateData(widget.parseWeatherData, widget.parseAirPollution);
    getCurrentUser(); // 초기화 될때마다 유저 정보 불러오기
    readPM().whenComplete(() => setState(() {})); // readPM() 끝나고 setState 하기
  }

  // 날씨 업데이트
  void updateData(dynamic weatherData, dynamic airData) {
    Model model = Model(); // 날씨 Condition Model 객체
    double temp2 = weatherData['main']['temp']; // 온도
    int condition = weatherData['weather'][0]['id']; // 날씨 id
    int index = airData['list'][0]['main']['aqi']; // 미세먼지 단계 (ex. 1,2,3,4,5...)
    des = weatherData['weather'][0]['description']; // 날씨 설명
    pm10 = airData['list'][0]['components']['pm10']; // 미세먼지 수치 불러오기
    pm2_5 = airData['list'][0]['components']['pm2_5']; // 초미세먼지 수치 불러오기
    temp = temp2.round(); // 반올림
    cityName = weatherData['name']; // 도시명
    icon = model.getWeatherIcon(condition); // 날씨 Condition 불러오기
    airIcon = model.getAirIcon(index); // 미세먼지 아이콘 불러오기
    airState = model.getAirCondition(index); // 미세먼지 상태 불러오기

    print('날씨 불러오기 완료');
  }

  // 시스템 시간 불러오기 함수
  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("hh:mm a").format(now);
  }

  // 현재 위치로 업데이트
  void getCurrentLocation() async {
    print('날씨 업데이트를 시작합니다.');

    Mylocation myLocation = Mylocation();
    await myLocation.getMyCurrentLocation();
    currentLatitude = myLocation.latitude2; // 위도 변수 삽입
    currentLongitude = myLocation.longitude2; // 경도 변수 삽입
    print(currentLatitude);
    print(currentLongitude);

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$currentLatitude&lon=$currentLongitude&appid=$apiKey&units=metric',
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$currentLatitude&lon=$currentLongitude&appid=$apiKey');

    var weatherData = await network.getJsonData(); // api값을 그릇에 담기 (날씨 정보)
    print(weatherData);

    var airData = await network.getAirData(); // api값을 그릇에 담기 (미세먼지 정보)
    print(airData);

    widget.parseWeatherData = weatherData; // 새로운 날씨 데이터 삽입
    widget.parseAirPollution = airData; // 새로운 공기 데이터 삽입
    print('새로운 날씨, 공기 데이터 업데이트 완료');
  }

  // 라즈베리파이 측정 값 가져오기
  Future<void> readPM() async {
    final databaseReference = await FirebaseDatabase(
            databaseURL:
                "https://meonji-6fb27-default-rtdb.asia-southeast1.firebasedatabase.app/")
        .reference(); // realtime database 인스턴스
    await databaseReference.once().then((DataSnapshot snapshot) {
      rasPM_10 = snapshot.value['pm']['pm']['pm10']; // pm10값 가져오기
      rasPM_25 = snapshot.value['pm']['pm']['pm25']; // pm2.5값 가져오기
      rasPM_date = snapshot.value['pm']['pm']['time']; // 측정 날짜값 가져오기
    });
  }

  // 오른쪽 하단 우리집은? 클릭했을때 메시지 띄우기
  void rasPMClick() {
    showDialog(
      context: context,
      // barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // Dialog 제목
          title: Column(
            children: <Widget>[
              new Text(
                "우리집 미세먼지는 지금!",
                style: GoogleFonts.lato(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "미세먼지: $rasPM_10 ㎍/m³",
                style: GoogleFonts.lato(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              new Text(
                "초미세먼지: $rasPM_25 ㎍/m³",
                style: GoogleFonts.lato(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              new Text(
                "업데이트 날짜: $rasPM_date\n(일.월.년 시간 순서입니다!)",
                style: GoogleFonts.lato(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 바디를 appbar까지 확장
      appBar: AppBar(
        // title: Text(''), // 타이틀 필요없음...
        backgroundColor: Colors.transparent, // 배경 없애기
        elevation: 0.0,
        leading: IconButton(
          // 현재 위치 버튼
          icon: Icon(Icons.near_me),
          onPressed: () async {
            getCurrentLocation(); // 현재 위치 불러오기
            updateData(widget.parseWeatherData,
                widget.parseAirPollution); // 날씨, 공기 데이터 업데이트
            await Future.delayed(
              // 딜레이...
              const Duration(milliseconds: 1500),
              () {
                setState(
                  () {
                    print('현재 위치 버튼 클릭 완료');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            '현재 위치의 날씨정보를 불러옵니다.(화면이 바뀌지 않으면 한번 더 눌러주세요^^)'),
                      ),
                    );
                  },
                );
              },
            );
          },
          iconSize: 40.0,
        ),
        actions: [
          IconButton(
            // 위치 찾기 버튼
            icon: Icon(
              Icons.location_searching,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Search();
                  },
                ),
              );
            },
            iconSize: 40.0,
          ),
          IconButton(
            // 로그아웃 버튼
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              _authentification.signOut(); // 로그아웃
              // Navigator.pop(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return LoginSignupScreen(); // 로그인 페이지로 이동
              //     },
              //   ),
              // );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      LoginSignupScreen(), // 로그인 페이지로 이동
                ),
              );
            },
            iconSize: 40.0,
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'image/background.jpg',
              fit: BoxFit.cover, // 배경 늘리기
              width: double.infinity, // 여백 없애기
              height: double.infinity, // 여백 없애기
            ),
            // 날씨 정보 보여주기 컨테이너
            Container(
              padding: EdgeInsets.all(20.0),
              child:
                  // 1번 Column
                  Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Column 사이 공백 넣기
                children: [
                  // 확보할 수 있는 공간 최대로 하는 Widget
                  Expanded(
                    // 1-1번 Column
                    child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Column 사이 공백 넣기
                        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬
                        children: [
                          // 1-1-1번 Column
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 텍스트 정렬
                            children: [
                              SizedBox(
                                height: 150.0,
                              ),
                              // 위치
                              Text('$cityName',
                                  style: GoogleFonts.lato(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Row(
                                children: [
                                  // 시간
                                  TimerBuilder.periodic(
                                    (Duration(minutes: 1)),
                                    builder: (context) {
                                      return Text(
                                        '${getSystemTime()}',
                                        style: GoogleFonts.lato(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      );
                                    },
                                  ),
                                  // 요일
                                  Text(
                                    DateFormat(' - EEEE, ').format(date),
                                    style: GoogleFonts.lato(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                  // 일 월 년
                                  Text(
                                    DateFormat('d MMM, yyy').format(date),
                                    style: GoogleFonts.lato(
                                        fontSize: 16.0, color: Colors.white),
                                  )
                                ],
                              )
                            ],
                          ),
                          // 1-1-2번 Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$temp\u2103', // 기온 표시 유니코드
                                  style: GoogleFonts.lato(
                                      fontSize: 85.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white)),
                              Row(
                                children: [
                                  icon,
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    '$des',
                                    style: GoogleFonts.lato(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          )
                        ]),
                  ),
                  // 1-2번 Column
                  Column(
                    children: [
                      Divider(
                        height: 15.0,
                        thickness: 2.0,
                        color: Colors.white30,
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Row 사이 공백 넣기
                        children: [
                          // 측정 지표, 이미지, 상태
                          Column(
                            children: [
                              Text(
                                'AQI(대기질지수)',
                                style: GoogleFonts.lato(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              airIcon,
                              SizedBox(height: 10.0),
                              airState,
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '미세먼지',
                                style: GoogleFonts.lato(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '$pm10',
                                style: GoogleFonts.lato(
                                    fontSize: 24.0, color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '㎍/m³',
                                style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '초미세먼지',
                                style: GoogleFonts.lato(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '$pm2_5',
                                style: GoogleFonts.lato(
                                    fontSize: 24.0, color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '㎍/m³',
                                style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              rasPMClick();
                            },
                            child: Column(
                              children: [
                                Text(
                                  '우리집은?',
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '$rasPM_10',
                                  style: GoogleFonts.lato(
                                      fontSize: 24.0, color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '㎍/m³',
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
