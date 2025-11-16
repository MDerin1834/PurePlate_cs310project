import 'package:flutter/material.dart';
import 'package:healthtrack_cs310project/screens/home_screen.dart';
import 'package:healthtrack_cs310project/screens/recipes_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      '/recipes': (context) => const RecipesScreen()
    }
  ));
}
