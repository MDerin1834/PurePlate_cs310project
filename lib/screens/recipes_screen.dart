import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/widgets/recipe_tile_widget.dart';
import 'package:pure_plate/models/recipe.dart';

class _RecipeSearchBarWidgetState extends State<RecipeSearchBarWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.tealAccent),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: IconButton(
                    onPressed: () => _controller.clear(),
                    icon: const Icon(Icons.clear, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, '/filter'),
              icon: const Icon(Icons.tune, color: Colors.black),
              tooltip: 'Filter',
            ),
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
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SizedBox(
            width: 280,
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
    final favourites = recipeProvider.favouriteRecipes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Icon(Icons.favorite, color: Colors.redAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Your Favorites',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (favourites.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No favorite recipes yet',
                style: TextStyle(color: Colors.white38),
              ),
            ),
          )
        else
          RecipesListWidget(recipes: favourites),
      ],
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
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Icon(Icons.restaurant_menu, color: Colors.tealAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'All Recipes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (allRecipes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No recipes available',
                style: TextStyle(color: Colors.white38),
              ),
            ),
          )
        else
          RecipesListWidget(recipes: allRecipes),
      ],
    );
  }
}

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PurePlateAppScaffold(
      pageIndex: 1,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RecipeSearchBarWidget(),
                  const SizedBox(height: 10),
                  const FavouriteRecipesListWidget(),
                  const SizedBox(height: 30),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.white12,
                  ),
                  const SizedBox(height: 30),
                  const AllRecipesListWidget(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
