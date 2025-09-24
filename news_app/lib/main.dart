import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- Import GetX
import 'package:news_app/screens/api_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ganti MaterialApp menjadi GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ApiScreen(),
    );
  }
}
