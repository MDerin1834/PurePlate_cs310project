import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';

// 1. KİŞİSEL BİLGİ SATIRI
class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70, fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}

// 2. HEDEFLER KARTI
class GoalsCard extends StatelessWidget {
  final String title;
  final List<String> goals;

  const GoalsCard({required this.title, required this.goals, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 15),
              ...goals.map((goal) => Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 10),
                    Expanded(child: Text(goal, style: TextStyle(color: Colors.white70, fontSize: 14))),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ANA EKRAN
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Sayfa ilk açıldığında veriyi çekmeyi deniyoruz
  @override
  void initState() {
    super.initState();
    // Ekrana çizildikten hemen sonra çalışır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        // Eğer UserProfileProvider içinde fetchUserProfile fonksiyonu varsa onu çağırırız.
        // Genelde constructor'da çağrılır ama burada manuel tetiklemek garanti olur.
        // context.read<UserProfileProvider>().fetchUserProfile(); // (Bu metod varsa açabilirsin)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = context.watch<UserProfileProvider>();
    final userProfile = userProfileProvider.userProfile;
    final isLoading = userProfileProvider.isLoading;

    // 1. DURUM: GERÇEKTEN YÜKLENİYORSA
    if (isLoading) {
      return PurePlateAppScaffold(
        pageIndex: 2,
        body: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black)), // Siyah zemin
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.tealAccent),
                  SizedBox(height: 20),
                  Text("Loading Profile...", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 2. DURUM: YÜKLEME BİTTİ AMA PROFİL YOK (HATA/BOŞ)
    if (userProfile == null) {
      return PurePlateAppScaffold(
        pageIndex: 2,
        body: Stack(
          children: [
            Positioned.fill(child: Image.network('https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353', fit: BoxFit.cover)),
            Positioned.fill(child: Container(color: Colors.black.withOpacity(0.8))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.orangeAccent),
                  SizedBox(height: 20),
                  Text(
                    "Profile Not Found",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We couldn't load your profile data.",
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
                    onPressed: () {
                      // Burası önemli: Eğer provider'da fetch fonksiyonun varsa onu çağır.
                      // Yoksa sadece setState yaparak widget'ı yenilemeye çalışır.
                      // context.read<UserProfileProvider>().fetchUserProfile();
                      setState(() {});
                    },
                    icon: Icon(Icons.refresh),
                    label: Text("Retry"),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: Text("Log Out", style: TextStyle(color: Colors.redAccent)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 3. DURUM: VERİ GELDİ, EKRANI GÖSTER
    return PurePlateAppScaffold(
      pageIndex: 2,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.95)],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('My Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.tealAccent.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)],
                      border: Border.all(color: Colors.tealAccent, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email_outlined, color: Colors.white54, size: 16),
                        SizedBox(width: 8),
                        Text(userProfile.email, style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Personal Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 15),
                            ProfileInfoCard(title: 'Name', value: userProfile.name),
                            ProfileInfoCard(title: 'Age', value: '${userProfile.age} years'),
                            ProfileInfoCard(title: 'Diet Type', value: userProfile.dietType),
                            ProfileInfoCard(title: 'Calorie Target', value: '${userProfile.calorieTarget} kcal'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GoalsCard(
                    title: 'Current Goals',
                    goals: [
                      'Daily calorie intake: ${userProfile.calorieTarget} kcal',
                      'Daily protein intake: ${userProfile.proteinTarget}g',
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                      icon: Icon(Icons.edit),
                      label: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: BorderSide(color: Colors.redAccent.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.black.withOpacity(0.3)),
                      onPressed: () async {
                        await context.read<AuthProvider>().logout();
                        if (context.mounted) Navigator.popAndPushNamed(context, '/login');
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}