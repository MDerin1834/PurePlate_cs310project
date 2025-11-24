import 'package:flutter/material.dart';
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

void main() {
  runApp(MaterialApp(
    theme: purePlateTheme,
    initialRoute: '/onboarding',
    routes: {
      '/onboarding': (context) => const OnboardingScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/reset': (context) => const ResetPasswordScreen(),
      '/home': (context) => const HomeScreen(),
      '/': (context) => const HomeScreen(), // Default route
      '/recipes': (context) => const RecipesScreen(),
      '/filter': (context) => const RecipeFilteringScreen(),
      '/filtered': (context) => const FilteredRecipesScreen(),
      '/recipe-details': (context) => const RecipeDetailsScreen(),
      '/profile': (context) => const ProfileScreen(),
      '/edit-profile': (context) => const EditProfileScreen(),
      '/records': (context) => const RecordsScreen(),
    },
  ));
}