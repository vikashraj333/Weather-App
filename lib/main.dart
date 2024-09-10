import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/consts/our_themes.dart';
import 'package:weather_app/weather_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
      title: "Weather App",
    );
  }
}
