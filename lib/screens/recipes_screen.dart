import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/favourites_provider.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
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
  const FavouriteRecipesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final recipes = recipeProvider.recipes;
    final favouritesProvider = context.watch<FavouritesProvider>();
    final favourites = favouritesProvider.favourites;

    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Favorites',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          if (favourites.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No favorite recipes yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            RecipesListWidget(recipes: recipes.where((r) => favourites.contains(r.name)).toList()), // TODO: use recipe.id instead of recipe.name
        ],
      ),
    );
  }
}

class AllRecipesListWidget extends StatelessWidget {
  const AllRecipesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final allRecipes = recipeProvider.recipes;

    if (recipeProvider.isLoading) {
      return SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'All Recipes',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          if (allRecipes.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No recipes available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            RecipesListWidget(recipes: allRecipes),
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
            AllRecipesListWidget(),
          ],
        ),
      ),
      pageIndex: 1,
    );
  }
}