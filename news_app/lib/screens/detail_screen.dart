import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
    // Skema Warna
    const Color primaryTextColor = Colors.white;
    const Color contentCardColor = Colors.white;
    const Color darkOverlay = Colors.black;

    final imageUrl =
        newsDetail['image']?['large'] ?? newsDetail['image']?['small'] ?? '';
    final otherNews = allNews
        .where((news) => news['link'] != newsDetail['link'])
        .toList();

    // Menggabungkan konten asli dengan teks placeholder (Lorem Ipsum)
    final originalContent =
        newsDetail['content'] ??
        newsDetail['contentSnippet'] ??
        'No content available.';
    const loremIpsum =
        "\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        "\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        "\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.";

    final fullContent = originalContent + loremIpsum;

    return Scaffold(
      backgroundColor: contentCardColor,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar dengan Gambar Latar Belakang
          SliverAppBar(
            backgroundColor: darkOverlay,
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            pinned: true,
            stretch: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: primaryTextColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.bookmark_border,
                  color: primaryTextColor,
                  size: 28,
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[800]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          darkOverlay.withOpacity(0.9),
                        ],
                        stops: const [0.5, 1.0],
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
                        color: primaryTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Konten Putih yang Bisa di-scroll
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: contentCardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Penulis
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsDetail['creator']?.first ?? 'Nadine Petrolli',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Author • ${formatDate(newsDetail['pubDate'] ?? DateTime.now().toIso8601String())}',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Konten Berita
                  Text(
                    fullContent, // Gunakan variabel konten yang baru
                    style: GoogleFonts.poppins(fontSize: 16, height: 1.7),
                  ),
                  const SizedBox(height: 30),

                  // Judul "Berita Lainnya"
                  Text(
                    "Berita Lainnya",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),

          // 3. Daftar Berita Lainnya
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final otherNewsItem = otherNews[index];
              return InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        newsDetail: otherNewsItem,
                        allNews: allNews,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          otherNewsItem['image']?['small'] ?? '',
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 100,
                                height: 80,
                                color: Colors.grey[200],
                              ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          otherNewsItem['title'] ?? 'No Title',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: otherNews.length > 5 ? 5 : otherNews.length),
          ),
        ],
      ),
    );
  }
}
