import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class MainController extends GetxController {
  @override
  void onInit() async {
    await getUserLocation();
    getCurrentWeatherData = getCurrentWeather(latitude.value, longitude.value);
    getHourlyWeatherData = getHourlyWeather(latitude.value, longitude.value);
    super.onInit();
  }

  var isDark = false.obs;
  dynamic getCurrentWeatherData;
  dynamic getHourlyWeatherData;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoaded = false.obs;

  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  getUserLocation() async {
    var isLocationEnabled;
    var userPermission;

    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return Future.error("Location is not enabled");
    }
    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever) {
      return Future.error("Permission is denied for forever");
    } else if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();
      if (userPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      isLoaded.value = true;
    });
  }
}
