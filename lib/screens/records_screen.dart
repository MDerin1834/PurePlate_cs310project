import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';
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
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondary,
          child: Icon(
            Icons.restaurant,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          meal.recipeName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(timeFormat.format(meal.createdAt)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 1.5),
              ),
              child: Text(
                '${meal.calories} kcal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            ),
            if (onEdit != null) ...[
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: onEdit,
                tooltip: 'Edit meal',
              ),
            ],
            if (onDelete != null) ...[
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Delete meal',
              ),
            ],
          ],
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
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$current / $target',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
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

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Edit Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Meal Name',
                prefixIcon: Icon(Icons.restaurant),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories',
                prefixIcon: Icon(Icons.local_fire_department),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final caloriesText = caloriesController.text.trim();

              if (name.isEmpty || caloriesText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final calories = int.tryParse(caloriesText);
              if (calories == null || calories <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter valid calories'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Update meal in Firestore
              await context.read<MealLogProvider>().updateMeal(
                meal.id,
                name,
                calories,
              );

              Navigator.pop(dialogContext);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ Meal updated!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
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
          title: Text('Delete Meal'),
          content: Text('Are you sure you want to delete this meal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<MealLogProvider>().deleteMeal(mealId);

                Navigator.of(dialogContext).pop();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Meal deleted successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealProvider = context.watch<MealLogProvider>();

    // Get today's meals
    final today = DateTime.now();
    final todayMeals = mealProvider.mealLogs.where((meal) {
      return meal.createdAt.year == today.year &&
          meal.createdAt.month == today.month &&
          meal.createdAt.day == today.day;
    }).toList();

    final totalCalories = mealProvider.todayCalories;

    return PurePlateAppScaffold(
      pageIndex: 0,
      body: mealProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Daily Records',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: theme.colorScheme.primary,
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                      DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Today's Meals (${todayMeals.length})",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),

            // Today's Meals - From Firestore
            if (todayMeals.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.no_meals_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No meals logged today',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap "Log Meal" on the home screen to add one!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...todayMeals.map((meal) {
                return DailyRecordCard(
                  meal: meal,
                  onEdit: () => _editMeal(context, meal),
                  onDelete: () => _deleteMeal(context, meal.id),
                );
              }),

            SizedBox(height: 30),

            // Daily Goals Section
            Text(
              'Daily Goals Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            NutrientProgressCard(
              label: 'Calories',
              current: totalCalories,
              target: 2000,
              color: Colors.orange,
            ),
            SizedBox(height: 10),
            NutrientProgressCard(
              label: 'Protein',
              current: 65,
              target: 80,
              color: Colors.blue,
            ),

            SizedBox(height: 30),
            Divider(thickness: 2, color: theme.colorScheme.primary),
            SizedBox(height: 20),

            // Weekly Summary
            Text(
              'Weekly & Monthly Track',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.green.shade700,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_view_week,
                          color: Colors.green.shade700,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'This Week',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildStatRow(context, 'Total meals logged',
                        '${mealProvider.mealLogs.length}', Colors.green),
                    _buildStatRow(context, 'Avg. calories',
                        '${totalCalories > 0 ? totalCalories : 0} kcal', Colors.orange),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}