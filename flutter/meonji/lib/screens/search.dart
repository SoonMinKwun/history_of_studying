// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:meonji/screens/weather_screen.dart';
import 'package:meonji/data/network.dart'; // 날씨데이터 관련
import 'package:meonji/api/key.dart'; // API Key
import 'package:meonji/data/my_location.dart'; // 위치정보관련

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // 지역 텍스트 컨트롤러
  TextEditingController stateController = TextEditingController();
  late String state; // 지역명
  late double currentLatitude; // 최근 위도 변수 선언
  late double currentLongitude; // 최근 경도 변수 선언
  bool api_null_check = true; // api null 체크

  // 지역 가져오기
  void searchLocation() {
    setState(
      () {
        state = stateController.text;
        print('$state 의 날씨를 가져옵니다...');
      },
    );
  }

  // 입력한 지역의 날씨, 공기 데이터 가져와서 보내주기
  void sendLocation() async {
    Mylocation myLocation = Mylocation();
    await myLocation.getMyCurrentLocation();
    currentLatitude = myLocation.latitude2; // 위도 변수 삽입
    currentLongitude = myLocation.longitude2; // 경도 변수 삽입
    print(currentLatitude);
    print(currentLongitude);

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?q=$state&appid=$apiKey&units=metric',
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$currentLatitude&lon=$currentLongitude&appid=$apiKey');

    var weatherData = await network.getJsonData(); // api값을 그릇에 담기 (날씨 정보)
    print(weatherData);

    var airData = await network.getAirData(); // api값을 그릇에 담기 (미세먼지 정보)
    print(airData);

    // API 불러오기 실패 처리
    if (weatherData == null || airData == null) {
      print('옳바르지 않은 도시명입니다.');
      api_null_check = true; // api가 null
    } else {
      // api가 not null
      api_null_check = false;
      // weather_screen으로 빌더를 넘기고 weatherData값 전달해서 라우트
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WeatherScreen(
                parseWeatherData: weatherData, parseAirPollution: airData);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 배경 없애기
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 40.0,
        ),
      ),
      // 키보드 없애기 기능
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Stack(
                children: [
                  Image.asset(
                    'image/background.jpg',
                    fit: BoxFit.cover, // 배경 늘리기
                    width: double.infinity, // 여백 없애기
                    height: double.infinity, // 여백 없애기
                  ),

                  // 검색창 컨테이너
                  Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(20.0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50.0,
                          ),

                          // 지역 입력 텍스트 폼
                          TextField(
                            controller: stateController, // 컨트롤러 배정
                            decoration: InputDecoration(
                              hintText: '지역을 입력하세요 :)',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 3.0),
                              ),
                            ),
                          ),

                          // 검색하기 버튼 폼
                          TextButton.icon(
                            onPressed: () async {
                              searchLocation();
                              sendLocation();
                              // 에러메시지
                              await Future.delayed(
                                // 딜레이...
                                const Duration(milliseconds: 1200),
                                () {
                                  if (api_null_check == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('존재하지 않는 지역입니다ㅠㅠ'),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(
                              Icons.location_searching,
                            ),
                            label: Text('검색하기'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
