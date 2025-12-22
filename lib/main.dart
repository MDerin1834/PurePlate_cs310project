import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/favourites_provider.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
// 1. DÜZELTME: Provider dosya adınızın 'schedule_provider.dart' olduğundan emin olun
import 'package:pure_plate/providers/scheduled_provider.dart';

import 'package:pure_plate/widgets/auth_gate.dart';
import 'firebase_options.dart';
import 'package:pure_plate/screens/onboarding_screen.dart';
import 'package:pure_plate/screens/login_screen.dart';
import 'package:pure_plate/screens/register_screen.dart';
import 'package:pure_plate/screens/reset_password_screen.dart';
import 'package:pure_plate/screens/home_screen.dart';
import 'package:pure_plate/screens/recipes_screen.dart';
import 'package:pure_plate/screens/recipe_filtering_screen.dart';
import 'package:pure_plate/screens/filtered_recipes_screen.dart';
import 'package:pure_plate/screens/profile_screen.dart';
import 'package:pure_plate/screens/edit_profile_screen.dart';
import 'package:pure_plate/screens/records_screen.dart';
// 2. YENİ EKRAN İMPORTU:
import 'package:pure_plate/screens/scheduled_recipes_screen.dart';
import 'package:pure_plate/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => RecipeProvider()),

            ChangeNotifierProxyProvider<AuthProvider, ScheduleProvider>(
              create: (context) => ScheduleProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => ScheduleProvider(auth),
            ),
            ChangeNotifierProxyProvider<AuthProvider, MealLogProvider>(
              create: (context) => MealLogProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => MealLogProvider(auth),
            ),
            ChangeNotifierProxyProvider<AuthProvider, UserProfileProvider>(
              create: (context) => UserProfileProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => UserProfileProvider(auth),
            ),
            ChangeNotifierProxyProvider<AuthProvider, FavouritesProvider>(
              create: (context) => FavouritesProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => FavouritesProvider(auth),
            ),
          ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: purePlateTheme,
      initialRoute: '/',
      debugShowCheckedModeBanner: false, // Debug bandını kapatmak isterseniz
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/': (context) => const AuthGate(),
        '/recipes': (context) => const RecipesScreen(),
        '/filter': (context) => const RecipeFilteringScreen(),
        '/filtered': (context) => const FilteredRecipesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/records': (context) => const RecordsScreen(),
        // 4. YENİ ROTA (ROUTE):
        // Eğer ScheduledRecipesScreen içinde const constructor varsa 'const' ekleyebilirsiniz.
        '/scheduled': (context) => const ScheduledRecipesScreen(),
      },
    );
  }
}