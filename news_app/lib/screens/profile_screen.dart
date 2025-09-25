import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Colors.grey;
    const Color cardBackgroundColor = Color(0xFF1E1E1E);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Akun Saya",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- BAGIAN HEADER PROFIL ---
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'), // Gambar profil placeholder
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF121212), width: 3),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "Kautsar", // Nama placeholder
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                "kautsar@example.com", // Email placeholder
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 30),

              // --- BAGIAN STATISTIK ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("86", "Bookmarks"),
                    _buildStatItem("125", "Dibaca"),
                    _buildStatItem("2", "Kategori"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- BAGIAN MENU ---
              _buildMenuSectionTitle("Pengaturan"),
              _buildMenuOption(
                icon: Icons.notifications_outlined,
                title: "Notifikasi",
                onTap: () {},
              ),
              _buildMenuOption(
                icon: Icons.lock_outline,
                title: "Privasi Akun",
                onTap: () {},
              ),
              _buildMenuOption(
                icon: Icons.language_outlined,
                title: "Bahasa",
                onTap: () {},
              ),
              
              const SizedBox(height: 20),
              _buildMenuSectionTitle("Bantuan"),
               _buildMenuOption(
                icon: Icons.help_outline,
                title: "Pusat Bantuan",
                onTap: () {},
              ),
              _buildMenuOption(
                icon: Icons.info_outline,
                title: "Tentang Aplikasi",
                onTap: () {},
              ),
              
              const SizedBox(height: 20),
              _buildMenuOption(
                icon: Icons.logout,
                title: "Keluar",
                isLogout: true, // Membuat teks menjadi merah
                onTap: () {},
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk item statistik
  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  // Helper widget untuk judul section menu
  Widget _buildMenuSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  // Helper widget untuk setiap item menu
  Widget _buildMenuOption({required IconData icon, required String title, required VoidCallback onTap, bool isLogout = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.redAccent : Colors.grey, size: 28),
            const SizedBox(width: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.redAccent : Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}