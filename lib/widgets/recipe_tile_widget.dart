import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';

class RecipeDescriptionWidget extends StatelessWidget {
  final Recipe recipe;
  const RecipeDescriptionWidget({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text('${recipe.calories} kcal'),
                Text('${recipe.cookingTime} min cook time'),
                recipe.isVegetarian
                    ? Text('Vegetarian', style: TextStyle(color: Colors.green))
                    : SizedBox.shrink(),
                recipe.isLactoseFree
                    ? Text(
                        'Lactose Free',
                        style: TextStyle(color: Colors.green),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 10),
            recipe.isFavourite ? Icon(Icons.favorite) : SizedBox.shrink(),
            Spacer(),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {},
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
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.teal, width: 4),
      ),
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: isHorizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(recipe.imageURL),
                  SizedBox(width: 10),
                  Expanded(child: RecipeDescriptionWidget(recipe: recipe)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(recipe.imageURL),
                  SizedBox(height: 10),
                  Expanded(child: RecipeDescriptionWidget(recipe: recipe)),
                ],
              ),
      ),
    );
  }
}
