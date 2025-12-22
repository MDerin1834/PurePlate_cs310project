import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/providers/favourites_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    final theme = Theme.of(context);

    final favouritesProvider = context.watch<FavouritesProvider>();
    final favourites = favouritesProvider.favourites;

    return PurePlateAppScaffold(
      pageIndex: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Stack(
              children: [
                Image.network(
                  recipe.imageURL,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: theme.colorScheme.secondary,
                      child: Icon(
                        Icons.restaurant,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        favourites.contains(recipe.name) ? Icons.favorite : Icons.favorite_border, // TODO: use recipe.id instead of recipe.name
                        color: favourites.contains(recipe.name) ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        if (favourites.contains(recipe.name)) {
                          favouritesProvider.deleteFavourite(recipeId: recipe.name);
                        } else {
                          favouritesProvider.addFavourite(recipe.name);
                        }
                        /*ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Favorite toggle not implemented'),
                            duration: Duration(seconds: 1),
                          ),
                        );*/
                      },
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Name
                  Text(
                    recipe.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Recipe Info Row
                  Row(
                    children: [
                      _buildInfoChip(
                        context: context,
                        icon: Icons.local_fire_department,
                        label: '${recipe.calories} kcal',
                        color: Colors.orange,
                      ),
                      SizedBox(width: 10),
                      _buildInfoChip(
                        context: context,
                        icon: Icons.timer,
                        label: '${recipe.cookingTime} min',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Dietary Tags
                  Wrap(
                    spacing: 8,
                    children: [
                      if (recipe.isVegetarian)
                        Chip(
                          label: Text('Vegetarian'),
                          backgroundColor: Colors.green.shade100,
                          avatar: Icon(Icons.eco, size: 16, color: Colors.green),
                        ),
                      if (recipe.isLactoseFree)
                        Chip(
                          label: Text('Lactose-Free'),
                          backgroundColor: Colors.blue.shade100,
                          avatar: Icon(Icons.water_drop, size: 16, color: Colors.blue),
                        ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Divider(thickness: 2, color: theme.colorScheme.primary),
                  SizedBox(height: 20),

                  // Ingredients Section
                  Text(
                    'Ingredients',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  if (recipe.ingredients.isEmpty)
                    Text(
                      'No ingredients listed',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    )
                  else
                    ...recipe.ingredients.map(
                          (ingredient) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ingredient,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: 20),
                  Divider(thickness: 2, color: theme.colorScheme.primary),
                  SizedBox(height: 20),

                  // Instructions Section
                  Text(
                    'Instructions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    recipe.instructions.isEmpty
                        ? 'No instructions provided'
                        : recipe.instructions,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Log this recipe as a meal
                            await context.read<MealLogProvider>().logMeal(
                              recipe.name,
                              recipe.calories,
                              recipe.protein,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('✅ ${recipe.name} added to your log!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // Optionally navigate to records screen
                              Navigator.pushNamed(context, '/records');
                            }
                          },
                          icon: Icon(Icons.add_circle),
                          label: Text('Add to Log'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showScheduleDialog(context);
                          },
                          icon: Icon(Icons.schedule),
                          label: Text('Schedule'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select date and time for this meal:'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Meal scheduled for ${date.day}/${date.month} at ${time.hour}:${time.minute}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text('Pick Date & Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}