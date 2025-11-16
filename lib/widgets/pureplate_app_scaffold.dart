import 'package:flutter/material.dart';
import 'package:healthtrack_cs310project/widgets/pureplate_app_navbar.dart';

class PurePlateAppScaffold extends StatelessWidget {
  final Widget body;
  final int pageIndex;
  const PurePlateAppScaffold({required this.body, required this.pageIndex, super.key});

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
    );
  }
}
