import 'package:flutter/material.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';

// MealRecord Model Class
class MealRecord {
  final String mealName;
  final int calories;
  final String time;

  const MealRecord({
    required this.mealName,
    required this.calories,
    required this.time,
  });
}

class DailyRecordCard extends StatelessWidget {
  final String mealName;
  final int calories;
  final String time;
  final VoidCallback? onDelete;

  const DailyRecordCard({
    required this.mealName,
    required this.calories,
    required this.time,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          mealName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(time),
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
                '$calories kcal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            ),
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

class AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const AchievementBadge({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 140,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 30),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  // Initial meals list
  List<MealRecord> todaysMeals = [
    MealRecord(
      mealName: 'Pizza Express Margherita',
      calories: 1170,
      time: '08:30 AM',
    ),
    MealRecord(
      mealName: 'Lamb and Lemon Souvlaki',
      calories: 1163,
      time: '01:00 PM',
    ),
    MealRecord(
      mealName: 'Sticky Chicken',
      calories: 408,
      time: '07:30 PM',
    ),
  ];

  // Calculate total calories dynamically
  int _calculateTotalCalories() {
    return todaysMeals.fold(0, (sum, meal) => sum + meal.calories);
  }

  // Delete meal with confirmation dialog
  void _deleteMeal(int index) {
    final mealToDelete = todaysMeals[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Meal'),
          content: Text(
            'Are you sure you want to delete "${mealToDelete.mealName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todaysMeals.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Meal deleted successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
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
    final totalCalories = _calculateTotalCalories();

    return PurePlateAppScaffold(
      pageIndex: 0,
      body: SingleChildScrollView(
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
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Today's Meals (${todaysMeals.length})",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),

            // Today's Meals - Dynamic List
            if (todaysMeals.isEmpty)
            // Empty state
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
                    ],
                  ),
                ),
              )
            else
            // Meals list with delete buttons
              ...todaysMeals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;
                return DailyRecordCard(
                  mealName: meal.mealName,
                  calories: meal.calories,
                  time: meal.time,
                  onDelete: () => _deleteMeal(index),
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
              current: totalCalories, // Dynamic calculation
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

            // Weekly & Monthly Track
            Text(
              'Weekly & Monthly Track',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            // Weekly Summary
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
                    _buildStatRow(context, 'Days on track', '5/7', Colors.green),
                    _buildStatRow(context, 'Avg. calories', '1850 kcal', Colors.orange),
                    _buildStatRow(context, 'Avg. protein', '75g', Colors.blue),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Achievements
            Text(
              'Achievements & Badges',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AchievementBadge(
                    icon: Icons.local_fire_department,
                    title: '7 Day Streak',
                    description: 'Logged meals for 7 days',
                    color: Colors.orange,
                  ),
                  AchievementBadge(
                    icon: Icons.emoji_events,
                    title: 'Goal Master',
                    description: 'Hit calorie goal 5x',
                    color: Colors.amber,
                  ),
                  AchievementBadge(
                    icon: Icons.eco,
                    title: 'Veggie Lover',
                    description: 'Tried 10 veggie meals',
                    color: Colors.green,
                  ),
                  AchievementBadge(
                    icon: Icons.favorite,
                    title: 'Health Hero',
                    description: 'Stayed on track',
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, Color color) {
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