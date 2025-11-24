import 'package:flutter/material.dart';
import 'package:pure_plate/data/recipes.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/widgets/recipe_tile_widget.dart';
import 'package:pure_plate/models/recipe.dart';

class _RecipeSearchBarWidgetState extends State<RecipeSearchBarWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 45,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search recipes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/filter'),
            label: Text('Apply Filter'),
            icon: Icon(Icons.add),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}

class RecipeSearchBarWidget extends StatefulWidget {
  const RecipeSearchBarWidget({super.key});

  @override
  State<RecipeSearchBarWidget> createState() => _RecipeSearchBarWidgetState();
}

class RecipesListWidget extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipesListWidget({required this.recipes, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) => Center(
          child: SizedBox(
            width: 400,
            height: 200,
            child: RecipeTileWidget(recipe: recipes[index], isHorizontal: true),
          ),
        ),
      ),
    );
  }
}

class FavouriteRecipesListWidget extends StatelessWidget {
  final _favourites = recipes.where((r) => r.isFavourite).toList();
  FavouriteRecipesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Favourites',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          RecipesListWidget(recipes: _favourites),
        ],
      ),
    );
  }
}

class SuggestedRecipesListWidget extends StatelessWidget {
  final _favourites = recipes.where((r) => r.isFavourite).toList();
  SuggestedRecipesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'We\'ve been inspired by the recipes you liked',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          RecipesListWidget(recipes: _favourites),
        ],
      ),
    );
  }
}

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PurePlateAppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            RecipeSearchBarWidget(),
            SizedBox(height: 20),
            FavouriteRecipesListWidget(),
            const Divider(
              height: 25,
              thickness: 5,
              endIndent: 0,
              color: Colors.grey,
            ),
            SuggestedRecipesListWidget(),
          ],
        ),
      ),
      pageIndex: 1,
    );
  }
}
