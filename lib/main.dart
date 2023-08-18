import 'package:flutter/material.dart';
import 'package:weather_app/weather_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true), //to change anything
      //at all we can do easily with the .copywith
      home: const WeatherApp(),
    );
  }
}
