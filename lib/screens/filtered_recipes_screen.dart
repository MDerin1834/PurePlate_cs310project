import 'package:flutter/material.dart';
import 'package:pure_plate/models/filter.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/widgets/recipe_tile_widget.dart';
import 'package:pure_plate/data/recipes.dart';

class FilteredRecipesScreen extends StatelessWidget {
  const FilteredRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Filter args = ModalRoute.of(context)!.settings.arguments as Filter;
    final filtered = recipes.where(args.matches).toList();
    return PurePlateAppScaffold(
      pageIndex: 1,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Filtered Recipes',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Based on your criteria',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text('Refine Filters'),
                  onPressed: () => Navigator.pushNamed(context, '/filter'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filtered.length,
                itemBuilder: (context, index) => Center(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: RecipeTileWidget(
                      recipe: filtered[index],
                      isHorizontal: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
