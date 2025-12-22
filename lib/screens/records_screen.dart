import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';
import 'package:pure_plate/models/meal_log.dart';
import 'package:intl/intl.dart';

class DailyRecordCard extends StatelessWidget {
  final MealLog meal;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const DailyRecordCard({
    required this.meal,
    this.onDelete,
    this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant,
                color: Colors.tealAccent,
                size: 20,
              ),
            ),
            title: Text(
              meal.recipeName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                timeFormat.format(meal.createdAt),
                style: TextStyle(color: Colors.white70),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Text(
                    '${meal.calories} kcal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (onEdit != null) ...[
                  SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                    onPressed: onEdit,
                  ),
                ],
                if (onDelete != null) ...[
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NutrientProgressCard extends StatelessWidget {
  final String label;
  final int current;
  final int target;
  final Color color;

  const NutrientProgressCard({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (current / target).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$current / $target ${label == 'Calories' ? 'kcal' : 'g'}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  void _editMeal(BuildContext context, MealLog meal) {
    final nameController = TextEditingController(text: meal.recipeName);
    final caloriesController = TextEditingController(text: meal.calories.toString());
    final proteinController = TextEditingController(text: meal.protein.toString());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Edit Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Meal Name',
                prefixIcon: Icon(Icons.restaurant),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories',
                prefixIcon: Icon(Icons.local_fire_department),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Protein (g)',
                prefixIcon: Icon(Icons.fitness_center),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final name = nameController.text.trim();
              final caloriesText = caloriesController.text.trim();
              final proteinText = proteinController.text.trim();

              if (name.isEmpty || caloriesText.isEmpty || proteinText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields'), backgroundColor: Colors.orange),
                );
                return;
              }

              final calories = int.tryParse(caloriesText);
              final protein = int.tryParse(proteinText);

              if (calories == null || calories <= 0 || protein == null || protein < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter valid values'), backgroundColor: Colors.orange),
                );
                return;
              }

              await context.read<MealLogProvider>().updateMeal(
                meal.id,
                name,
                calories,
                protein,
              );

              Navigator.pop(dialogContext);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Meal updated!'), backgroundColor: Colors.green),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteMeal(BuildContext context, String mealId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Delete Meal'),
          content: Text('Are you sure you want to delete this meal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await context.read<MealLogProvider>().deleteMeal(mealId);
                Navigator.of(dialogContext).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meal deleted successfully'), backgroundColor: Colors.green),
                  );
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealLogProvider>();

    final userProfile = context.watch<UserProfileProvider>().userProfile;
    final calorieTarget = userProfile?.calorieTarget ?? 2000;
    final proteinTarget = userProfile?.proteinTarget ?? 50;

    final today = DateTime.now();
    final todayMeals = mealProvider.mealLogs.where((meal) {
      return meal.createdAt.year == today.year &&
          meal.createdAt.month == today.month &&
          meal.createdAt.day == today.day;
    }).toList();

    final totalCalories = mealProvider.todayCalories;
    final totalProtein = mealProvider.todayProtein;

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
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: mealProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.tealAccent))
                : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Daily Records',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.calendar_month, color: Colors.tealAccent),
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Colors.teal,
                                      onPrimary: Colors.white,
                                      surface: Colors.grey.shade900,
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Today's Meals (${todayMeals.length})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 15),

                  if (todayMeals.isEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.no_meals_outlined, size: 60, color: Colors.white24),
                              SizedBox(height: 16),
                              Text(
                                'No meals logged today',
                                style: TextStyle(color: Colors.white60, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap "Log Meal" on Home screen to add!',
                                style: TextStyle(color: Colors.tealAccent.withOpacity(0.7), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...todayMeals.map((meal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: DailyRecordCard(
                          meal: meal,
                          onEdit: () => _editMeal(context, meal),
                          onDelete: () => _deleteMeal(context, meal.id),
                        ),
                      );
                    }),

                  SizedBox(height: 30),

                  Text(
                    'Daily Goals Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  SizedBox(height: 15),

                  NutrientProgressCard(
                    label: 'Calories',
                    current: totalCalories,
                    target: calorieTarget,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(height: 12),
                  NutrientProgressCard(
                    label: 'Protein',
                    current: totalProtein,
                    target: proteinTarget,
                    color: Colors.tealAccent,
                  ),

                  SizedBox(height: 30),
                  Divider(thickness: 1, color: Colors.white24),
                  SizedBox(height: 20),

                  Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.teal.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_view_week, color: Colors.tealAccent),
                                SizedBox(width: 10),
                                Text(
                                  'This Week',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            _buildStatRow('Total meals logged', '${mealProvider.mealLogs.length}', Colors.tealAccent),
                            _buildStatRow('Avg. calories', '${totalCalories > 0 ? totalCalories : 0} kcal', Colors.orangeAccent),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
        ],
      ),
    );
  }
}