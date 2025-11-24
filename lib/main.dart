import 'package:flutter/material.dart';
import 'package:pure_plate/screens/home_screen.dart';
import 'package:pure_plate/screens/recipes_screen.dart';
import 'package:pure_plate/screens/recipe_filtering_screen.dart';
import 'package:pure_plate/screens/filtered_recipes_screen.dart';
import 'package:pure_plate/theme.dart';

void main() {
  runApp(MaterialApp(
    theme: purePlateTheme,
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      '/recipes': (context) => const RecipesScreen(),
      '/filter': (context) => const RecipeFilteringScreen(),
      '/filtered': (context) => const FilteredRecipesScreen(),
    }
  ));
}
