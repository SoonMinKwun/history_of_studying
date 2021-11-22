// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';

class Mylocation {
  late double latitude2;
  late double longitude2;

  Future<void> getMyCurrentLocation() async {
    try {
      print('my_location.dart is running...');
      Position position = await Geolocator.getCurrentPosition(
          // 위치 정보를 position에 삽입
          desiredAccuracy: LocationAccuracy.high); // 위치 정확도
      latitude2 = position.latitude;
      longitude2 = position.longitude;
    } catch (e) {
      print('인터넷 연결에 문제가 생겼습니다!');
    }
  }
}
