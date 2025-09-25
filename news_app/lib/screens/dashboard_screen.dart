import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/news_controller.dart';
import 'package:news_app/screens/api_screen.dart';
import 'package:news_app/screens/profile_screen.dart'; // <-- Jangan lupa import
import 'package:news_app/screens/bookmark_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // KODE BARU
// ...

final List<Widget> pages = [
  ApiScreen(),
  BookmarkScreen(),
  const ProfileScreen(), // <-- Ganti dengan halaman yang baru
];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewsController());
    
    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(index: controller.tabIndex.value, children: pages)),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Obx(() => BottomNavigationBar(
                backgroundColor: const Color(0xFF1E1E1E),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[600],
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: controller.tabIndex.value,
                onTap: controller.changeTabIndex,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                ],
              )),
        ),
      ),
    );
  }
}