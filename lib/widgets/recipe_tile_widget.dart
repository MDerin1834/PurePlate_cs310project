import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/providers/favourites_provider.dart';

class RecipeDescriptionWidget extends StatelessWidget {
  final Recipe recipe;
  const RecipeDescriptionWidget({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favouritesProvider = context.watch<FavouritesProvider>();
    final favourites = favouritesProvider.favourites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${recipe.calories} kcal',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '${recipe.cookingTime} min cook time',
                  style: theme.textTheme.bodyMedium,
                ),
                if (recipe.isVegetarian)
                  Text(
                    'Vegetarian',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (recipe.isLactoseFree)
                  Text(
                    'Lactose Free',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 10),
            if (favourites.contains(recipe.name)) // TODO: use recipe.id instead of recipe.name
              Icon(
                Icons.favorite,
                color: Colors.red.shade400,
              ),
            Spacer(),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/recipe-details',
                  arguments: recipe,
                );
              },
              label: Text('Go to meal'),
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}

class RecipeTileWidget extends StatelessWidget {
  final Recipe recipe;
  final bool isHorizontal;

  const RecipeTileWidget({
    required this.recipe,
    this.isHorizontal = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: isHorizontal
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                recipe.imageURL,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: theme.colorScheme.secondary,
                    child: Icon(
                      Icons.restaurant,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: RecipeDescriptionWidget(recipe: recipe)),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                recipe.imageURL,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 120,
                    color: theme.colorScheme.secondary,
                    child: Icon(
                      Icons.restaurant,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: RecipeDescriptionWidget(recipe: recipe)),
          ],
        ),
      ),
    );
  }
}