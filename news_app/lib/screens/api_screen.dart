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
      style: ElevatedButton.styleFrom(backgroundColor: _selectedCategory == type ? Colors.blue : Colors.grey),
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
      appBar: AppBar(title: Text('News App')),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  _applySearch('');
                },
                icon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 20),
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredNews.isEmpty
                ? Center(child: Text('No news Found'))
                : ListView.builder(
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final item = _filteredNews[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(newsDetail: item)));
                        },
                        title: Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(formatDate(item['isoDate']), maxLines: 2, overflow: TextOverflow.ellipsis),
                        leading: Image.network(item['image']['small']),
                        // trailing: Text(item['isoDate']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}