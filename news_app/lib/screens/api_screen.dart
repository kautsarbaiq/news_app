import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/news_controller.dart';
import 'package:news_app/screens/detail_screen.dart';

// UBAH DARI StatelessWidget MENJADI GetView<NewsController>
class ApiScreen extends GetView<NewsController> {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengan GetView, kita tidak perlu Get.find() lagi.
    // Cukup panggil 'controller' yang sudah disediakan.

    const Color scaffoldBackground = Color(0xFF121212);
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Color(0xFFAAAAAA);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16.0,
        backgroundColor: scaffoldBackground,
        elevation: 0,
        title: Obx(() => controller.isSearching.value
            ? TextField(
                controller: controller.searchController,
                autofocus: true,
                style: GoogleFonts.poppins(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Cari berita...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(color: secondaryTextColor),
                ),
              )
            : Text('News Update', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold))),
        actions: [
          Obx(() => IconButton(
                icon: Icon(controller.isSearching.value ? Icons.close : Icons.search),
                onPressed: controller.toggleSearch,
              )),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          labelStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedLabelColor: secondaryTextColor,
          labelColor: primaryTextColor,
          indicatorColor: primaryTextColor,
          tabs: controller.categories.map((c) => Tab(text: c.toUpperCase())).toList(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryTextColor));
        }
        return controller.isSearching.value
            ? ListView.builder(
                itemCount: controller.filteredNews.length,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemBuilder: (context, index) => buildSmallCard(controller.filteredNews[index], controller.filteredNews),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.filteredNews.length > 5 ? 5 : controller.filteredNews.length,
                        padding: const EdgeInsets.only(left: 16),
                        itemBuilder: (context, index) => buildBigCard(controller.filteredNews[index], controller.filteredNews),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Local News", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                      itemCount: controller.filteredNews.length > 5 ? controller.filteredNews.length - 5 : 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildSmallCard(controller.filteredNews[index + 5], controller.filteredNews),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
      }),
    );
  }

  String formatDate(String date) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (e) { return 'Invalid date'; }
  }

  Widget buildBigCard(Map<String, dynamic> item, List<Map<String, dynamic>> allNews) {
    return InkWell(
      onTap: () => Get.to(() => DetailScreen(newsDetail: item, allNews: allNews)),
      child: Container(
        width: 300, margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(image: NetworkImage(item['image']['small']), fit: BoxFit.cover, onError: (e,s){}),
        ),
        child: Stack(
          children: [
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [Colors.black.withOpacity(0.8), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
            Positioned(
              bottom: 20, left: 20, right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${item['creator'] ?? 'Unknown'} • ${formatDate(item['isoDate'])}', style: GoogleFonts.poppins(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSmallCard(Map<String, dynamic> item, List<Map<String, dynamic>> allNews) {
    return InkWell(
      onTap: () => Get.to(() => DetailScreen(newsDetail: item, allNews: allNews)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'], maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('${item['creator'] ?? 'Unknown'} • ${formatDate(item['isoDate'])}', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(item['image']['small'], width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(width: 100, height: 100, color: Colors.grey[800], child: const Icon(Icons.broken_image)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}