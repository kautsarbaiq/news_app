import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/api/api.dart'; // Pastikan path ini benar!

class NewsController extends GetxController with GetSingleTickerProviderStateMixin {
  final _api = Api();
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  var tabIndex = 0.obs;
  final List<String> categories = ['semua', 'nasional', 'ekonomi', 'teknologi', 'olahraga'];
  var allNews = <Map<String, dynamic>>[].obs;
  var filteredNews = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;
  final box = GetStorage();
  var bookmarks = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    loadBookmarks();
    fetchNews(categories.first);
    tabController.addListener(() {
      if (tabController.indexIsChanging) fetchNews(categories[tabController.index]);
    });
    searchController.addListener(() => applySearch(searchController.text));
  }
  
  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) => tabIndex.value = index;

  void loadBookmarks() {
    final saved = box.read<List>('bookmarks');
    if (saved != null) bookmarks.value = List<Map<String, dynamic>>.from(saved);
  }
  
  void toggleBookmark(Map<String, dynamic> newsItem) {
    final isExist = bookmarks.any((item) => item['link'] == newsItem['link']);
    if (isExist) {
      bookmarks.removeWhere((item) => item['link'] == newsItem['link']);
      Get.snackbar('Dihapus', 'Berita dihapus dari bookmark');
    } else {
      bookmarks.add(newsItem);
      Get.snackbar('Disimpan', 'Berita ditambahkan ke bookmark');
    }
    box.write('bookmarks', bookmarks.toList());
  }

  bool isBookmarked(Map<String, dynamic> newsItem) => bookmarks.any((item) => item['link'] == newsItem['link']);

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
    filteredNews.value = query.isEmpty
        ? allNews
        : allNews.where((item) => item['title'].toString().toLowerCase().contains(query.toLowerCase())).toList();
  }

  void toggleSearch() {
    isSearching.toggle();
    if (!isSearching.value) searchController.clear();
  }
}