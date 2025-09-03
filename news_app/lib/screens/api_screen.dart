import 'package:flutter/material.dart';
import 'package:news_app/api/api.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:intl/intl.dart';

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

    _applySearch(String query) {
      if (query.isEmpty) {
        setState(() {
          _filteredNews = _allNews;
        });
      } else {
        _filteredNews = _allNews.where((item) {
          final title = item['title'].toString().toLowerCase();
          final content = item['contentSnippet'].toString().toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || content.contains(search);
        }).toList();
      }
    }

    void initState() {
      super.initState();
      fetchNews(_selectedCategory);
      _searchController.addListener(() {
        _applySearch(_searchController.text);
      });
      {}
    }

    Widget categoryButton(String label, String type) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedCategory == type
              ? Colors.blue
              : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _selectedCategory = type;
          });
        },
        child: Text(label),
      );
    }

    String formatDate(String isoDate) {
      DateTime dateTime = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy, HH:mm', 'id').format(dateTime);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('News App')),
        body: Expanded(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    categoryButton('semua', ''),
                    categoryButton('nasional', 'nasional'),
                    categoryButton('internasional', 'internasional'),
                    categoryButton('ekonomi', 'ekonomi'),
                    categoryButton('olahraga', 'olahraga'),
                    categoryButton('teknologi', 'teknologi'),
                    categoryButton('hiburan', 'hiburan'),
                    categoryButton('gaya-hidup', 'gaya-hidup'),
                  ],
                ),
              ),
              Expanded(
                child: 
                isLoading ?
                Center(child: CircularProgressIndicator(),) : 
                _filteredNews.isEmpty ?
                Center(child: Text('No news found'),) : 
                  ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (context, index) => Divider(
                        indent: 16,
                        endIndent: 16,
                        color: Colors.grey[300],
                      ),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(newsDetail: item),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // BAGIAN GAMBAR
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 120,
                                    height: 100,
                                    child: Image.network(
                                      item['image']['small'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.broken_image),
                                            );
                                          },
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // BAGIAN TEKS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['contentSnippet'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        item['isoDate'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },

              ),
            ],
          ),
        ),
      );
    }
  }
}
