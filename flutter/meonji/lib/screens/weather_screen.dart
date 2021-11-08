// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 폰트
import 'package:flutter_svg/flutter_svg.dart'; // svg 사용하기 위함
import 'package:intl/intl.dart'; // DateTime Format
import 'package:timer_builder/timer_builder.dart'; // 시스템 시간 불러오기 위함

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
  var date = DateTime.now(); // 오늘 날짜

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

  // 시스템 시간 불러오기 함수
  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("hh:mm a").format(now);
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
          onPressed: () {},
          iconSize: 30.0,
        ),
        actions: [
          IconButton(
            // 위치 찾기 버튼
            icon: Icon(
              Icons.location_searching,
            ),
            onPressed: () {},
            iconSize: 30.0,
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // 텍스트 정렬
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
                                Text('Seoul',
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
                                        print('${getSystemTime()}');
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
                                Text('18\u2103', // 기온 표시 유니코드
                                    style: GoogleFonts.lato(
                                        fontSize: 85.0,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white)),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'svg/climacon-sun.svg',
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'clear sky',
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
                                Image.asset(
                                  'image/bad.png',
                                  width: 37.0,
                                  height: 35.0,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '"매우 나쁨"',
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
                                  '미세먼지',
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '174.75',
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
                                  '우리집은?',
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '14.13',
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
                          ],
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
