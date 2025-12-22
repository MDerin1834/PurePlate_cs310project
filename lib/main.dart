import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
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
import 'package:pure_plate/screens/recipe_details_screen.dart';
import 'package:pure_plate/screens/profile_screen.dart';
import 'package:pure_plate/screens/edit_profile_screen.dart';
import 'package:pure_plate/screens/records_screen.dart';
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
            ChangeNotifierProxyProvider<AuthProvider, MealLogProvider>(
              create: (context) => MealLogProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => MealLogProvider(auth),
            ),
            ChangeNotifierProxyProvider<AuthProvider, UserProfileProvider>(
              create: (context) => UserProfileProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => UserProfileProvider(auth),
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
        '/recipe-details': (context) => const RecipeDetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/records': (context) => const RecordsScreen(),
      },
    );
  }
}