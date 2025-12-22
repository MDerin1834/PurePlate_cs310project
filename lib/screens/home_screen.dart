import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
import 'package:pure_plate/providers/scheduled_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/services/recipe_service.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
import 'package:pure_plate/screens/recipe_details_screen.dart';

class CalorieBudgetTrackerWidget extends StatelessWidget {
  final int calorieBudget;
  final int currentCalories;
  final double size = 250;

  const CalorieBudgetTrackerWidget({
    required this.calorieBudget,
    required this.currentCalories,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 20.0,
                value: 1.0,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                color: Colors.tealAccent,
                backgroundColor: Colors.transparent,
                strokeWidth: 20.0,
                value: calorieBudget > 0 ? currentCalories / calorieBudget : 0,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Center(
            child: Container(
              width: size - 50,
              height: size - 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Remaining',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${calorieBudget - currentCalories}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'kcal',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogMealViewWidget extends StatelessWidget {
  const LogMealViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealLogProvider>();
    final todayCalories = mealProvider.todayCalories;

    final userProfile = context.watch<UserProfileProvider>().userProfile;
    final calorieTarget = userProfile?.calorieTarget ?? 2000;

    return Center(
      child: Column(
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalorieBudgetTrackerWidget(
            calorieBudget: calorieTarget,
            currentCalories: todayCalories,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black87,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: Colors.tealAccent.withOpacity(0.4),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Log Meal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () async {
                  await _showLogMealDialog(context);
                },
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white60, width: 2),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.analytics_outlined),
                label: const Text(
                  'Records',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/records');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showLogMealDialog(BuildContext context) async {
    final recipeProvider = context.read<RecipeProvider>();
    final recipes = recipeProvider.recipes;

    if (recipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No recipes available. Please seed recipes first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Recipe? selectedRecipe;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Log a Meal', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select a recipe:',
                style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Recipe>(
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2C2C2C),
                    hint: const Text('Choose a recipe',
                        style: TextStyle(color: Colors.grey)),
                    value: selectedRecipe,
                    items: recipes.map((recipe) {
                      return DropdownMenuItem<Recipe>(
                        value: recipe,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '${recipe.calories} kcal • ${recipe.cookingTime} min',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Recipe? newValue) {
                      setState(() {
                        selectedRecipe = newValue;
                      });
                    },
                  ),
                ),
              ),
              if (selectedRecipe != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected: ${selectedRecipe!.name}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text('Calories: ${selectedRecipe!.calories} kcal',
                          style: const TextStyle(color: Colors.white70)),
                      Text('Time: ${selectedRecipe!.cookingTime} min',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: selectedRecipe == null
                  ? null
                  : () async {
                await context.read<MealLogProvider>().logMeal(
                  selectedRecipe!.name,
                  selectedRecipe!.calories,
                  selectedRecipe!.protein,
                );

                Navigator.pop(dialogContext);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          '✅ Meal logged successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Log Meal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const _ModernRecipeCard({required this.recipe});

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
        width: 220,
        margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final scheduleProvider = context.watch<ScheduleProvider>();

    final scheduledRecipesIDs = scheduleProvider.scheduledRecipes;
    final scheduledRecipes = recipeProvider.recipes.where((r) {
      for (final ids in scheduledRecipesIDs) {
        if (r.name == ids.recipeId) return true; // TODO: use r.id instead of r.name
      }

      return false;
    }).toList();

    return PurePlateAppScaffold(
      pageIndex: 0,
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
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "PurePlate",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.upload_file,
                                  color: Colors.orange),
                              tooltip: 'Seed Recipes',
                              onPressed: () async {
                                final recipeService = RecipeService();
                                await recipeService.seedRecipes();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          '✅ Recipes seeded! Check Firestore'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.logout_rounded,
                                  color: Colors.tealAccent),
                              tooltip: 'Logout',
                              onPressed: () => _handleLogout(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const LogMealViewWidget(),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Planlanmış yemekler varsa göster
                        if (scheduledRecipes.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 24, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.restaurant_menu,
                                        color: Colors.tealAccent, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Scheduled Recipes',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/scheduled');
                                    },
                                    child: const Text(
                                      'See All',
                                      style: TextStyle(color: Colors.tealAccent),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 8, bottom: 20),
                              scrollDirection: Axis.horizontal,
                              itemCount: scheduledRecipes.length,
                              itemBuilder: (context, index) => Center(
                                child: _ModernRecipeCard(
                                    recipe: scheduledRecipes[index]),
                              ),
                            ),
                          ),
                        ],

                        // Hiç planlanmış yemek yoksa bilgilendirme metni
                        if (scheduledRecipes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      color: Colors.white24, size: 40),
                                  SizedBox(height: 10),
                                  Text(
                                    "No scheduled meals yet.",
                                    style: TextStyle(color: Colors.white38),
                                  ),
                                  Text(
                                    "Go to Recipes to plan your week!",
                                    style: TextStyle(color: Colors.white24, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
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