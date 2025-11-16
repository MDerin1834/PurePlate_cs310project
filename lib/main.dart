import 'package:flutter/material.dart';
import 'package:pure_plate/screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
    }
  ));
}
