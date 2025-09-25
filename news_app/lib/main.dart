import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/screens/dashboard_screen.dart'; // Pastikan path ini benar

Future<void> main() async {
  // Wajib ada untuk inisialisasi GetStorage sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      // PASTIKAN BAGIAN INI BENAR
      home: DashboardScreen(),
    );
  }
}
