import 'package:flutter/material.dart';
import 'package:pure_plate/models/filter.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/data/ingredients.dart';

class SettingsContainer extends StatelessWidget {
  final Widget body;
  final String title;
  const SettingsContainer({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.teal, width: 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.start,
            ),
            body,
          ],
        ),
      ),
    );
  }
}

class PreferenceWidget extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const PreferenceWidget({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _RecipeFilteringScreen extends State<RecipeFilteringScreen> {
  var filter = Filter(maxCalories: 2000, cookingTime: 60, ingredients: {});
  final _controller = TextEditingController();

  void _toggleIngredient(String s) {
    if (filter.ingredients.contains(s)) {
      filter.ingredients.remove(s);
    } else {
      filter.ingredients.add(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PurePlateAppScaffold(
      pageIndex: 1,
      body: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Filter Recipes',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              SettingsContainer(
                title: 'Max Calories',
                body: Column(
                  children: [
                    Slider(
                      value: filter.maxCalories.toDouble(),
                      min: 100,
                      max: 2000,
                      onChanged: (val) =>
                          setState(() => filter.maxCalories = val.round()),
                    ),
                    Text('< ${filter.maxCalories} kcal'),
                  ],
                ),
              ),
              SettingsContainer(
                title: 'Max Cooking Time',
                body: Column(
                  children: [
                    Slider(
                      value: filter.cookingTime.toDouble(),
                      min: 1,
                      max: 60,
                      onChanged: (val) =>
                          setState(() => filter.cookingTime = val.round()),
                    ),
                    Text('< ${filter.cookingTime} min'),
                  ],
                ),
              ),
              SettingsContainer(
                title: 'Available Ingredients',
                body: Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Search ingredients',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: () => _controller.clear(),
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 70,
                        ),
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          final s = ingredients[index];
                          return ToggleButtons(
                            constraints: BoxConstraints(maxWidth: 120),
                            borderRadius: BorderRadius.circular(5),
                            isSelected: [filter.ingredients.contains(s)],
                            children: [
                              IntrinsicHeight(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Wrap(children: [Text(s)]),
                                ),
                              ),
                            ],
                            onPressed: (_) => setState(() {
                              _toggleIngredient(s);
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SettingsContainer(
                title: 'Preferences',
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      PreferenceWidget(
                        label: 'Gluten-free',
                        value: filter.isGlutenFree,
                        onChanged: (val) =>
                            setState(() => filter.isGlutenFree = val),
                      ),
                      PreferenceWidget(
                        label: 'Vegetarian',
                        value: filter.isVegetarian,
                        onChanged: (val) =>
                            setState(() => filter.isVegetarian = val),
                      ),
                      PreferenceWidget(
                        label: 'Lactose-free',
                        value: filter.isLactoseFree,
                        onChanged: (val) =>
                            setState(() => filter.isLactoseFree = val),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Apply the filter'),
        onPressed: () {},
      ),
    );
  }
}

class RecipeFilteringScreen extends StatefulWidget {
  const RecipeFilteringScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeFilteringScreen();
}
