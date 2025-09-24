import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/news_controller.dart';
import 'detail_screen.dart';

class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller. GetX akan mengelolanya secara otomatis.
    final NewsController controller = Get.put(NewsController());
    
    // Skema Warna
    const Color scaffoldBackground = Color(0xFF121212);
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Color(0xFFAAAAAA);
    const Color navBarColor = Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: scaffoldBackground,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        titleSpacing: 16.0,
        // Gunakan Obx untuk membuat AppBar reaktif terhadap state 'isSearching'
        title: Obx(() => controller.isSearching.value
            ? TextField(
                controller: controller.searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari berita...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(color: secondaryTextColor),
                ),
                style: GoogleFonts.poppins(color: primaryTextColor, fontSize: 18),
              )
            : Text(
                'News Update',
                style: GoogleFonts.poppins(
                    color: primaryTextColor, fontSize: 28, fontWeight: FontWeight.bold),
              )),
        actions: [
          Obx(() => IconButton(
                icon: Icon(controller.isSearching.value ? Icons.close : Icons.search, color: primaryTextColor),
                onPressed: () => controller.toggleSearch(),
              )),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          indicatorColor: primaryTextColor,
          labelColor: primaryTextColor,
          unselectedLabelColor: secondaryTextColor,
          labelStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          tabs: controller.categories.map((category) => Tab(text: category.toUpperCase())).toList(),
        ),
      ),
      // Body utama juga dibungkus Obx untuk menampilkan loading atau konten
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryTextColor));
        }

        return controller.isSearching.value
            // Tampilan saat mencari
            ? ListView.builder(
                itemCount: controller.filteredNews.length,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemBuilder: (context, index) => buildSmallCard(controller.filteredNews[index], controller.filteredNews),
              )
            // Tampilan default
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
                      child: Text("Local News", style: GoogleFonts.poppins(color: primaryTextColor, fontSize: 22, fontWeight: FontWeight.bold)),
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: navBarColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: primaryTextColor,
            unselectedItemColor: secondaryTextColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: 0,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders (sekarang menjadi method biasa di dalam StatelessWidget) ---
  
  String formatDate(String date) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget buildBigCard(Map<String, dynamic> item, List<Map<String, dynamic>> allNews) {
    return InkWell(
      onTap: () => Get.to(() => DetailScreen(newsDetail: item, allNews: allNews)),
      child: Container(
        // ... (UI untuk Big Card sama persis seperti sebelumnya)
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(item['image']['small']),
            fit: BoxFit.cover,
            onError: (e, s) {},
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20, left: 20, right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'], maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${item['creator'] ?? 'Unknown'} • ${formatDate(item['isoDate'])}',
                    style: GoogleFonts.poppins(color: Colors.white70)),
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
        // ... (UI untuk Small Card sama persis seperti sebelumnya)
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'], maxLines: 3, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('${item['creator'] ?? 'Unknown'} • ${formatDate(item['isoDate'])}',
                    style: GoogleFonts.poppins(color: const Color(0xFFAAAAAA), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item['image']['small'], width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100, height: 100, color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}