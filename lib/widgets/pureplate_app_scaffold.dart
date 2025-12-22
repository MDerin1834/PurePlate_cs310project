import 'package:flutter/material.dart';

class PurePlateAppScaffold extends StatelessWidget {
  final Widget body;
  final int pageIndex; // 0: Home, 1: Recipes, 2: Profile
  final FloatingActionButton? floatingActionButton;

  const PurePlateAppScaffold({
    required this.body,
    required this.pageIndex,
    this.floatingActionButton,
    super.key,
  });

  // Sayfa değiştirme mantığı
  void _onItemTapped(BuildContext context, int index) {
    if (index == pageIndex) return; // Zaten o sayfadaysak bir şey yapma

    // Sayfalar arası geçiş rotaları
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/recipes');
        break;
      case 2:
      // İŞTE ÇÖZÜM: 2. indexe (Profile) tıklandığında '/profile' rotasına git
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. DEĞİŞİKLİK: AppBar'ı kaldırdık.
      // Çünkü Home ve Profile ekranlarında kendi özel başlıklarımızı tasarladık.

      extendBody: true, // 2. DEĞİŞİKLİK: Body'i alt barın arkasına uzatır (Cam efekti için)

      body: body,

      floatingActionButton: floatingActionButton,

      bottomNavigationBar: Container(
        // 3. DEĞİŞİKLİK: Alt bar tasarımı (Karanlık & Cam Efekti)
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85), // Yarı saydam siyah
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // Container rengini kullansın
          selectedItemColor: Colors.tealAccent, // Aktif ikon rengi
          unselectedItemColor: Colors.grey.shade600, // Pasif ikon rengi
          type: BottomNavigationBarType.fixed,
          currentIndex: pageIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}