import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/api.dart'; // Sesuaikan path jika perlu

class NewsController extends GetxController with GetSingleTickerProviderStateMixin {
  // --- State Variables (dibuat reaktif dengan .obs) ---
  final _api = Api(); // instance dari API class kamu
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = ['semua', 'nasional', 'ekonomi', 'teknologi', 'olahraga'];
  
  var allNews = <Map<String, dynamic>>[].obs;
  var filteredNews = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;

  // --- Lifecycle Methods GetX ---
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    fetchNews(categories.first); // Ambil berita pertama kali

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        fetchNews(categories[tabController.index]);
      }
    });

    searchController.addListener(() {
      applySearch(searchController.text);
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // --- Logic Methods ---
  Future<void> fetchNews(String type) async {
    try {
      isLoading(true);
      final apiType = type == 'semua' ? '' : type;
      final data = await _api.getApi(type: apiType);
      allNews.value = data;
      filteredNews.value = data;
    } finally {
      isLoading(false);
    }
  }

  void applySearch(String query) {
    if (query.isEmpty) {
      filteredNews.value = allNews;
    } else {
      filteredNews.value = allNews.where((item) {
        final title = item['title'].toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    }
  }

  void toggleSearch() {
    isSearching.toggle();
    if (!isSearching.value) {
      searchController.clear();
      applySearch('');
    }
  }
}