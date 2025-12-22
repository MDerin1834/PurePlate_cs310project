import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/widgets/recipe_tile_widget.dart';
import 'package:pure_plate/data/recipes.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/services/recipe_service.dart';
import 'package:pure_plate/providers/recipe_provider.dart';

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
                value: currentCalories / calorieBudget,
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
                boxShadow: [
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
                  Text(
                    'Remaining',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${calorieBudget - currentCalories}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
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
    // Watch MealLogProvider for real-time calorie updates
    final mealProvider = context.watch<MealLogProvider>();
    final todayCalories = mealProvider.todayCalories;

    // ← ADD THIS: Watch UserProfileProvider for calorie target
    final userProfile = context.watch<UserProfileProvider>().userProfile;
    final calorieTarget = userProfile?.calorieTarget ?? 2000;

    return Center(
      child: Column(
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalorieBudgetTrackerWidget(
            calorieBudget: calorieTarget,  // ← CHANGED: Use dynamic value
            currentCalories: todayCalories,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(Icons.add_circle_outline),
                label: Text(
                  'Log Meal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () async {
                  await _showLogMealDialog(context);
                },
              ),
              SizedBox(width: 15),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white60, width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(Icons.analytics_outlined),
                label: Text(
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

  // Helper function to show recipe selection dialog
  Future<void> _showLogMealDialog(BuildContext context) async {
    final recipeProvider = context.read<RecipeProvider>();
    final recipes = recipeProvider.recipes;

    if (recipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
          title: Text('Log a Meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select a recipe:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Recipe>(
                    isExpanded: true,
                    hint: Text('Choose a recipe'),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${recipe.calories} kcal • ${recipe.cookingTime}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected: ${selectedRecipe!.name}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Calories: ${selectedRecipe!.calories} kcal'),
                      Text('Time: ${selectedRecipe!.cookingTime}'),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedRecipe == null
                  ? null
                  : () async {
                // Log meal to Firestore
                await context.read<MealLogProvider>().logMeal(
                  selectedRecipe!.name,
                  selectedRecipe!.calories,
                );

                Navigator.pop(dialogContext);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '✅ ${selectedRecipe!.name} logged! Check Records screen'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Log Meal'),
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

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
              (route) => false,
        );
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
                      Text(
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
                          // 🔥 TEMPORARY SEED BUTTON - Remove after seeding!
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.upload_file, color: Colors.orange),
                              tooltip: 'Seed Recipes',
                              onPressed: () async {
                                final recipeService = RecipeService();
                                await recipeService.seedRecipes();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✅ Recipes seeded! Check Firestore'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.logout_rounded, color: Colors.tealAccent),
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
                        SizedBox(height: 10),
                        LogMealViewWidget(),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.white24,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 24, bottom: 16),
                          child: Row(
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
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView.builder(
                            padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: recipes.length,
                            itemBuilder: (context, index) => Center(
                              child: Container(
                                width: 250,
                                margin: EdgeInsets.only(right: 16),
                                constraints: BoxConstraints(maxHeight: 400),
                                child: RecipeTileWidget(recipe: recipes[index]),
                              ),
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