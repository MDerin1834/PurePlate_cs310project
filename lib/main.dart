import 'package:flutter/material.dart';
import 'package:pure_plate/screens/home_screen.dart';
import 'package:pure_plate/screens/recipes_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      '/recipes': (context) => const RecipesScreen(),
    }
  ));
}
