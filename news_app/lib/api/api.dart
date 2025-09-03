import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  Future<List<Map<String, dynamic>>> getApi({String type = ''}) async {
    String url = 'https://berita-indo-api.vercel.app/v1/cnn-news/';
    if (type.isNotEmpty) {
      url += type;
    }
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final jsonList = json['data'] as List;
      return jsonList.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
