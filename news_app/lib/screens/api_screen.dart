import 'package:flutter/material.dart';
import 'package:news_app/api/api.dart';
import 'package:intl/intl.dart';

import 'detail_screen.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _selectedCategory = '';
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filteredNews = [];
  bool isLoading = false;

  Future<void> fetchNews(String type) async {
    setState(() {
      isLoading = true;
    });

    final data = await Api().getApi(type: type);
    setState(() {
      _allNews = data;
      _filteredNews = data;
      isLoading = false;
    });
  }

  _applySearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredNews = _allNews;
      });
    } else {
      setState(() {
        _filteredNews = _allNews.where((item) {
          final title = item['title'].toString().toLowerCase();
          final snippet = item['contentSnippet'].toString().toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || snippet.contains(search);
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews(_selectedCategory);
    _searchController.addListener(() {
      _applySearch(_searchController.text);
    });
  }

  Widget categoryButton(String label, String type) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == type ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = type;
        });
        fetchNews(type);
      },
      child: Text(label),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Padding hanya untuk judul
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kategori Berita',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            SizedBox(height: 10),

            // Padding untuk TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari berita...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: _applySearch,
              ),
            ),

            SizedBox(height: 20),

            // Padding untuk baris kategori
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // Padding ini agar tombol pertama tidak mepet kiri
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  categoryButton('Semua', ''),
                  categoryButton('Nasional', 'nasional'),
                  categoryButton('Ekonomi', 'ekonomi'),
                  categoryButton('Teknologi', 'teknologi'),
                  categoryButton('Olahraga', 'olahraga'),
                  categoryButton('Hiburan', 'hiburan'),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Expanded untuk daftar berita
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNews.length,
                itemBuilder: (context, index) {
                  final item = _filteredNews[index];
                  // Padding untuk setiap item di dalam list
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(newsDetail: item),
                          ),
                        );
                      },
                      title: Text(
                        item['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(formatDate(item['isoDate'])),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item['image']['small'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
