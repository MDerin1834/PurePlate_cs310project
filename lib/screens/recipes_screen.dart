import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/favourites_provider.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/screens/recipe_details_screen.dart';

class ModernRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const ModernRecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        width: 220, // Genişlik
        margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Koyu kart rengi
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ÜST KISIM: RESİM
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      recipe.imageURL,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.white54)),
                      ),
                    ),
                  ),
                  if (recipe.isVegetarian)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Veg",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ALT KISIM: BİLGİLER
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.tealAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.calories} kcal',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.tealAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.cookingTime} dk',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.black87, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeSearchBarWidgetState extends State<RecipeSearchBarWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Glassmorphism Search Field
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white24),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.tealAccent),
                  suffixIcon: IconButton(
                    onPressed: () => _controller.clear(),
                    icon: const Icon(Icons.clear, color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Teal Filter Button
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.tealAccent,
            ),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, '/filter'),
              icon: const Icon(Icons.tune, color: Colors.black87),
              tooltip: 'Apply Filter',
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
      height: 280,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 24, right: 8, bottom: 20),
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) => Center(
          child: ModernRecipeCard(recipe: recipes[index]),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.tealAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Your Favorites',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (favourites.isEmpty)
          Container(
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 40, color: Colors.white24),
                SizedBox(height: 10),
                Text(
                  'No favorite recipes yet',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          )
        else
          RecipesListWidget(
            recipes: recipes.where((r) => favourites.contains(r.name)).toList(),
          ),
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
        child: Center(
          child: CircularProgressIndicator(color: Colors.tealAccent),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.tealAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'All Recipes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (allRecipes.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No recipes available',
                style: TextStyle(color: Colors.white54),
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
          // 1. KATMAN: Arkaplan Resmi
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
            ),
          ),
          // 2. KATMAN: Gradyan Karartma
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          // 3. KATMAN: İçerik
          SafeArea(
            child: Column(
              children: [
                // Header Başlık
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discover",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Icon(Icons.local_dining, color: Colors.tealAccent, size: 28),
                    ],
                  ),
                ),

                // Kaydırılabilir İçerik
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const RecipeSearchBarWidget(),

                        const FavouriteRecipesListWidget(),

                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 20),

                        const AllRecipesListWidget(),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}