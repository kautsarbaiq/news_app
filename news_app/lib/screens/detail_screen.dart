import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  const DetailScreen({super.key, required this.newsDetail});

  // Helper method untuk format tanggal, bisa diletakkan di sini
  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Skema Warna Gelap
    const Color scaffoldBackground = Color(0xFF121212);
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Color(0xFFAAAAAA);

    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Custom App Bar (Back & Bookmark Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: primaryTextColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, color: primaryTextColor, size: 28),
                      onPressed: () {
                        // Aksi untuk menyimpan berita, bisa ditambahkan nanti
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Judul Berita
                Text(
                  newsDetail['title'] ?? 'No Title',
                  style: GoogleFonts.poppins(
                    color: primaryTextColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Info Sumber dan Tanggal
                Text(
                  'Source: ${newsDetail['creator'] ?? 'Unknown'} • ${formatDate(newsDetail['isoDate'])}',
                  style: GoogleFonts.poppins(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),

                // 4. Gambar Utama
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    // Gunakan gambar 'large' jika tersedia, jika tidak pakai 'small'
                    newsDetail['image']['large'] ?? newsDetail['image']['small'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),

                // 5. Konten Berita
                Text(
                  // API terkadang memberikan deskripsi yang sama di content dan contentSnippet
                  // Kita bisa tambahkan fallback jika 'content' null
                  newsDetail['content'] ?? newsDetail['contentSnippet'] ?? 'No content available.',
                  style: GoogleFonts.poppins(
                    color: primaryTextColor.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.7, // Jarak antar baris agar lebih mudah dibaca
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}