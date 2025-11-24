import 'package:flutter/material.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/widgets/recipe_tile_widget.dart';
import 'package:pure_plate/data/recipes.dart';

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
          CircularProgressIndicator(
            constraints: BoxConstraints(minWidth: size, minHeight: size),
            color: Colors.white,
            backgroundColor: Colors.teal,
            strokeWidth: 25.0,
            value: 0.0,
          ),
          CircularProgressIndicator(
            constraints: BoxConstraints(minWidth: size, minHeight: size),
            color: Colors.green,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            strokeWidth: 20.0,
            value: currentCalories / calorieBudget,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: BoxBorder.all(width: 3, color: Colors.red),
                  ),
                  child: Text(
                    'Remaining Calorie Budget',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${calorieBudget - currentCalories} kcal',
                  style: TextStyle(color: Colors.teal, fontSize: 20),
                ),
              ],
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
    return Center(
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CalorieBudgetTrackerWidget(
            calorieBudget: 3200,
            currentCalories: 1400,
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle),
            label: Text('Log Meal'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduled = [
      (1, DateTime(2025, 1, 1, 12, 0, 0)),
      (2, DateTime(2025, 1, 1, 18, 0, 0)),
    ];

    return PurePlateAppScaffold(
      pageIndex: 0,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            LogMealViewWidget(),
            const Divider(
              height: 25,
              thickness: 5,
              endIndent: 0,
              color: Colors.teal,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Scheduled Recipes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: scheduled.length,
                itemBuilder: (context, index) {
                  final hour = scheduled[index].$2.hour;
                  final minute = scheduled[index].$2.minute;
                  final hourString = hour.toString().padLeft(2, '0');
                  final minuteString = minute.toString().padLeft(2, '0');
                  var icon = Icons.wb_twilight;
                  if (hour >= 16) {
                    icon = Icons.mode_night;
                  } else if (hour >= 12) {
                    icon = Icons.wb_sunny;
                  }
                  final timeString = '$hourString:$minuteString';
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          constraints: BoxConstraints(maxHeight: 326),
                          child: RecipeTileWidget(
                            recipe: recipes[scheduled[index].$1],
                          ),
                        ),

                        Row(
                          spacing: 10,
                          children: [Icon(icon), Text(timeString)],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
