import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/api/api.dart';
import 'package:intl/intl.dart';
import 'detail_screen.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen>
    with SingleTickerProviderStateMixin {
  // --- State Variables ---
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'semua',
    'nasional',
    'ekonomi',
    'teknologi',
    'olahraga',
  ];
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filteredNews = [];
  bool isLoading = true;
  bool _isSearching = false;

  // --- Lifecycle Methods ---
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    fetchNews(_categories[0]);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        fetchNews(_categories[_tabController.index]);
      }
    });
    _searchController.addListener(() {
      _applySearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // --- Data & Logic ---
  Future<void> fetchNews(String type) async {
    setState(() => isLoading = true);
    final apiType = type == 'semua' ? '' : type;
    final data = await Api().getApi(type: apiType);
    if (mounted) {
      setState(() {
        _allNews = data;
        _filteredNews = data;
        isLoading = false;
      });
    }
  }

  void _applySearch(String query) {
    setState(() {
      _filteredNews = query.isEmpty
          ? _allNews
          : _allNews.where((item) {
              final title = item['title'].toString().toLowerCase();
              return title.contains(query.toLowerCase());
            }).toList();
    });
  }

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    // --- SKEMA WARNA ---
    const Color scaffoldBackground = Color(0xFF121212);
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Color(0xFFAAAAAA);
    const Color accentColor = Colors.white;
    const Color navBarColor = Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: scaffoldBackground,
      extendBody: true, // <-- PENTING: Untuk floating navigation bar
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        titleSpacing: 16.0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari berita...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(color: secondaryTextColor),
                ),
                style: GoogleFonts.poppins(
                  color: primaryTextColor,
                  fontSize: 18,
                ),
              )
            : Text(
                'News Update',
                style: GoogleFonts.poppins(
                  color: primaryTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: primaryTextColor,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: accentColor,
          labelColor: primaryTextColor,
          unselectedLabelColor: secondaryTextColor,
          labelStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
          tabs: _categories
              .map((category) => Tab(text: category.toUpperCase()))
              .toList(),
        ),
      ),
      // --- PERUBAHAN LOGIKA BODY ---
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : _isSearching
          // TAMPILAN SAAT MENCARI: HANYA SATU LIST VERTIKAL
          ? ListView.builder(
              itemCount: _filteredNews.length,
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ), // Padding bawah agar tidak tertutup nav bar
              itemBuilder: (context, index) =>
                  buildSmallCard(_filteredNews[index]),
            )
          // TAMPILAN DEFAULT: LAYOUT KOMPLEKS
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredNews.length > 5
                          ? 5
                          : _filteredNews.length,
                      padding: const EdgeInsets.only(left: 16),
                      itemBuilder: (context, index) =>
                          buildBigCard(_filteredNews[index]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Local News",
                      style: GoogleFonts.poppins(
                        color: primaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: _filteredNews.length > 5
                        ? _filteredNews.length - 5
                        : 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildSmallCard(_filteredNews[index + 5]),
                  ),
                  const SizedBox(
                    height: 100,
                  ), // Padding bawah agar tidak tertutup nav bar
                ],
              ),
            ),
      // --- PERUBAHAN NAVIGATION BAR ---
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(50), // Membuat jadi full rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomNavigationBar(
            backgroundColor:
                const Color.fromARGB(0, 255, 255, 255), // Transparan agar warna container terlihat
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: secondaryTextColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: 0,
            elevation: 0, // Hilangkan shadow bawaan
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Custom Widget Builders ---
  Widget buildBigCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(newsDetail: item)),
      ),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(item['image']['small']),
            fit: BoxFit.cover,
            onError: (e, s) {},
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item['creator'] ?? 'Unknown'} • ${formatDate(item['isoDate'])}',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSmallCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(newsDetail: item)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item['creator'] ?? 'Unknown'} • ${formatDate(item['isoDate'])}',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFAAAAAA),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item['image']['small'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
