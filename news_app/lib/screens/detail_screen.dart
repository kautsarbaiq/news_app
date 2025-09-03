import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  const DetailScreen({super.key, required this.newsDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail News")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(newsDetail['image']['small']),
          ),
          SizedBox(height: 10),
          Text(
            newsDetail['title'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(newsDetail['contentSnippet'], style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text(
            newsDetail['link'],
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
