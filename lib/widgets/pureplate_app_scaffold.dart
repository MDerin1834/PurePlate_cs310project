import 'package:flutter/material.dart';
import 'package:pure_plate/widgets/pureplate_app_navbar.dart';

class PurePlateAppScaffold extends StatelessWidget {
  final Widget body;
  final int pageIndex;
  final FloatingActionButton? floatingActionButton;
  const PurePlateAppScaffold({
    required this.body,
    required this.pageIndex,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pure Plate'),
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PurePlateAppNavigationBar(pageIndex: pageIndex),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
