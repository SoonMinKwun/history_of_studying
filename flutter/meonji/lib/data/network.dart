import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  final String url; // 날씨 정보
  final String url2; // 미세먼지 정보
  Network(this.url, this.url2);

  // 날씨 API
  Future<dynamic> getJsonData() async {
    // uri 파싱
    http.Response response = await http.get(Uri.parse(url));
    // api 호출 성공 시
    if (response.statusCode == 200) {
      String jsonData = response.body; // 바디부분 추출
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    }
  }

  // 미세먼지 API
  Future<dynamic> getAirData() async {
    // uri 파싱
    http.Response response = await http.get(Uri.parse(url2));
    // api 호출 성공 시
    if (response.statusCode == 200) {
      String jsonData = response.body; // 바디부분 추출
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    }
  }
}

// void fetchData() async {
//     // uri 파싱
//     http.Response response = await http.get(Uri.parse(
//         'https://samples.openweathermap.org/data/2.5/weather?q=London&appid=b1b15e88fa797225412429c1c50c122a1'));
//     // api 호출 성공 시
//     if (response.statusCode == 200) {
//       String jsonData = response.body; // 바디부분 추출
//       var parsingData = jsonDecode(jsonData);
//       var myJson = parsingData(jsonData)['weather'][0]['description'];
//       // 디코드 과정, api 호출 시 어떤 형태의 데이터가 올지 모름...
//       //그래서 변수 타입은 var, jsonDecode는 dynamic 타입을 받음
//       print(myJson);
//     } else {
//       print(response.statusCode); // statusCode가 몇인지 알기위해...
//     }
//   }
