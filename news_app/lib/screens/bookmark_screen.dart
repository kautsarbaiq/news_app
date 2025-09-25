import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/news_controller.dart';
import 'package:news_app/screens/detail_screen.dart';

class BookmarkScreen extends GetView<NewsController> {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (controller.bookmarks.isEmpty) {
          return Center(child: Text("Belum ada berita yang disimpan.", style: GoogleFonts.poppins(color: Colors.grey)));
        }
        return ListView.builder(
          itemCount: controller.bookmarks.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = controller.bookmarks[index];
            return InkWell(
              onTap: () => Get.to(() => DetailScreen(newsDetail: item, allNews: controller.bookmarks.toList())),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(item['image']['small'], width: 100, height: 100, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(width: 100, height: 100, color: Colors.grey[800]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => controller.toggleBookmark(item),
                            child: const Text("Hapus", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}