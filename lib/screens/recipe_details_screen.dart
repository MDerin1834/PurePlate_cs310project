import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;

    return PurePlateAppScaffold(
      pageIndex: 1,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              recipe.imageURL,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade900,
                  child: Center(
                    child: Icon(Icons.restaurant, color: Colors.white24, size: 80),
                  ),
                );
              },
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
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildGlassIconButton(
                        icon: recipe.isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: recipe.isFavourite ? Colors.redAccent : Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Favorite toggle coming soon!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildInfoBadge(
                              icon: Icons.local_fire_department_rounded,
                              label: '${recipe.calories} kcal',
                              color: Colors.orangeAccent,
                            ),
                            const SizedBox(width: 12),
                            _buildInfoBadge(
                              icon: Icons.timer_outlined,
                              label: '${recipe.cookingTime} min',
                              color: Colors.tealAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (recipe.isVegetarian)
                              _buildDietTag('Vegetarian', Colors.greenAccent),
                            if (recipe.isLactoseFree)
                              _buildDietTag('Lactose-Free', Colors.lightBlueAccent),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 20),
                        Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (recipe.ingredients.isEmpty)
                          const Text('No ingredients listed', style: TextStyle(color: Colors.white54))
                        else
                          ...recipe.ingredients.map((ingredient) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.tealAccent, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        const SizedBox(height: 30),
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            recipe.instructions.isEmpty
                                ? 'No instructions provided'
                                : recipe.instructions,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await context.read<MealLogProvider>().logMeal(
                          recipe.name,
                          recipe.calories,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ ${recipe.name} added to your log!'),
                              backgroundColor: Colors.teal,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.pushNamed(context, '/records');
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add to Log'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () => _showScheduleDialog(context),
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: const Text('Plan'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white60, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold
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
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
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

  Widget _buildDietTag(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.5)),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Schedule Meal', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select date and time for this meal:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Colors.tealAccent,
                          onPrimary: Colors.black,
                          surface: Colors.grey,
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null && context.mounted) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.tealAccent,
                            onPrimary: Colors.black,
                            surface: Colors.grey,
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Meal scheduled for ${date.day}/${date.month} at ${time.hour}:${time.minute}'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick Date & Time'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
