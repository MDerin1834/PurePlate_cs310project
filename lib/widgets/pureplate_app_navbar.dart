import 'package:flutter/material.dart';

class PurePlateAppNavigationBar extends StatelessWidget {
  final int pageIndex;
  const PurePlateAppNavigationBar({required this.pageIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: pageIndex,
        backgroundColor: Theme.of(context).colorScheme.primary,
        indicatorShape: CircleBorder(),
        onDestinationSelected: (index) {
          if (index == pageIndex) return;
          switch (index) {
            case 0: Navigator.pushNamed(context, '/home');
            case 1: Navigator.pushNamed(context, '/recipes');
            case 2: Navigator.pushNamed(context, '/profile');
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ]
    );
  }
}