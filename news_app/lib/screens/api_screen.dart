import 'package:flutter/material.dart';
import 'package:news_app/api/api.dart';
import 'package:news_app/screens/detail_screen.dart';

import 'package:intl/intl.dart';

class ScreenApi extends StatefulWidget {
  const ScreenApi({super.key});

  @override
  State<ScreenApi> createState() => _ScreenApiState();
}

class _ScreenApiState extends State<ScreenApi> {
  String _selectedCategory = '';

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filterNews = [];
  bool isLoading = false;

  Future<void> fetchNews(String type) async {
    setState(() {
      isLoading = true;
    });

    final data = await Api().getApi(type: type);
    setState(() {
      _allNews = data;
      _filterNews = data;
      isLoading = false;
    });

    _applySearch(String query) {
      if (query.isEmpty) {
        setState(() {
          _filterNews = _allNews;
        });
      } else {
        _filterNews = _allNews.where((item) {
          final title = item['title'].toString().toLowerCase();
          final snippet = item['contentSnippet'].toString().toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || snippet.contains(search);
        }).toList();
      }
    }

    void initState() {
      super.initState();
      fetchNews(_selectedCategory);
      _searchController.addListener(() {
        _applySearch(_searchController.text);
      });
    }
  }

  Widget categoryButton(String label, String category) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == category
            ? Colors.blue
            : Colors.grey[100],
        foregroundColor: _selectedCategory == category
            ? Colors.white
            : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Text(label),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MM yyyy, HH:mm').format(dateTime);
  }

  bool isBoomarked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('News App', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search news...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                categoryButton('semua', ''),
                SizedBox(width: 10),
                categoryButton('nasional', 'nasional'),
                SizedBox(width: 10),
                categoryButton('internasional', 'internasional'),
                SizedBox(width: 10),
                categoryButton('ekonomi', 'ekonomi'),
                SizedBox(width: 10),
                categoryButton('olahraga', 'olahraga'),
                SizedBox(width: 10),
                categoryButton('teknologi', 'teknologi'),
                SizedBox(width: 10),
                categoryButton('hiburan', 'hiburan'),
                SizedBox(width: 10),
                categoryButton('gaya-hidup', 'gaya-hidup'),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _filterNews.isEmpty
                ? Center(child: Text('No news Found'))
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _filterNews.length,
                      itemBuilder: (context, index) {
                        final item = _filterNews[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(newsDetail: item),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.only(bottom: 16.0),
                            elevation: 2.0,
                            shadowColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      item['image']['small'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['link'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isBoomarked = !isBoomarked;
                                          });
                                        },
                                        icon: Icon(
                                          isBoomarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                        ),
                                        constraints: BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),

                                  Text(
                                    item['contentSnippet'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),

                                  Text(
                                    formatDate(item['isoDate']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}