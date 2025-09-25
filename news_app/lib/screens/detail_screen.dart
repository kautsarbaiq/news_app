import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/news_controller.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  final List<Map<String, dynamic>> allNews;

  const DetailScreen({
    super.key,
    required this.newsDetail,
    required this.allNews,
  });

  String formatDate(String date) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();
    final imageUrl =
        newsDetail['image']?['large'] ?? newsDetail['image']?['small'] ?? '';
    final otherNews = allNews
        .where((news) => news['link'] != newsDetail['link'])
        .toList();
    final originalContent =
        newsDetail['content'] ?? newsDetail['contentSnippet'] ?? 'No content.';
    const loremIpsum =
        "\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    final fullContent = originalContent + loremIpsum;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            pinned: true,
            stretch: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Get.back(),
            ),
            actions: [
              Obx(
                () => IconButton(
                  icon: Icon(
                    controller.isBookmarked(newsDetail)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    size: 28,
                  ),
                  onPressed: () => controller.toggleBookmark(newsDetail),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: Colors.grey[800]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      newsDetail['title'] ?? 'No Title',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- PERUBAHAN DI SINI ---
          // Semua konten di bawah AppBar sekarang ada di dalam satu SliverToBoxAdapter
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
              ),
              padding: const EdgeInsets.only(top: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Konten utama (penulis & isi berita)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsDetail['creator']?.first ?? 'Nadine Petrolli',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Author • ${formatDate(newsDetail['pubDate'] ?? DateTime.now().toIso8601String())}',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          fullContent,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Berita Lainnya",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  // Daftar Berita Lainnya sekarang menjadi bagian dari Column ini
                  ...List.generate(
                    otherNews.length > 5 ? 5 : otherNews.length,
                    (index) {
                      final item = otherNews[index];
                      return InkWell(
                        onTap: () => Get.to(
                          () =>
                              DetailScreen(newsDetail: item, allNews: allNews),
                          preventDuplicates: false,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item['image']?['small'] ?? '',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'] ?? '',
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            formatDate(item['pubDate'] ?? ''),
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index <
                                  (otherNews.length > 5
                                      ? 4
                                      : otherNews.length - 1))
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFE0E0E0),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Spasi di paling bawah agar tidak terpotong nav bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
