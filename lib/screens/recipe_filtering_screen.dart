import 'dart:ui';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: body,
            ),
          ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
            activeTrackColor: Colors.tealAccent,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }
}

class RecipeFilteringScreen extends StatefulWidget {
  const RecipeFilteringScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeFilteringScreen();
}

class _RecipeFilteringScreen extends State<RecipeFilteringScreen> {
  var filter = Filter(maxCalories: 2000, cookingTime: 60, ingredients: {});
  final _controller = TextEditingController();

  void _toggleIngredient(String s) {
    setState(() {
      if (filter.ingredients.contains(s)) {
        filter.ingredients.remove(s);
      } else {
        filter.ingredients.add(s);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PurePlateAppScaffold(
      pageIndex: 1,
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
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Filter Recipes',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SettingsContainer(
                          title: 'Max Calories',
                          body: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: Colors.orangeAccent),
                                  Text(
                                    '${filter.maxCalories} kcal',
                                    style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.tealAccent,
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: Colors.tealAccent,
                                  overlayColor:
                                      Colors.tealAccent.withOpacity(0.2),
                                  valueIndicatorTextStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                child: Slider(
                                  value: filter.maxCalories.toDouble(),
                                  min: 100,
                                  max: 2000,
                                  divisions: 19,
                                  label: filter.maxCalories.toString(),
                                  onChanged: (val) => setState(
                                      () => filter.maxCalories = val.round()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SettingsContainer(
                          title: 'Max Cooking Time',
                          body: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.timer,
                                      color: Colors.blueAccent),
                                  Text(
                                    '${filter.cookingTime} min',
                                    style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.blueAccent,
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: Colors.blueAccent,
                                ),
                                child: Slider(
                                  value: filter.cookingTime.toDouble(),
                                  min: 5,
                                  max: 120,
                                  divisions: 23,
                                  label: filter.cookingTime.toString(),
                                  onChanged: (val) => setState(
                                      () => filter.cookingTime = val.round()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SettingsContainer(
                          title: 'Available Ingredients',
                          body: Column(
                            children: [
                              TextField(
                                controller: _controller,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search ingredients...',
                                  hintStyle:
                                      const TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.tealAccent),
                                  suffixIcon: IconButton(
                                    onPressed: () => _controller.clear(),
                                    icon: const Icon(Icons.clear,
                                        color: Colors.white54),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 180,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 3,
                                  ),
                                  itemCount: ingredients.length,
                                  itemBuilder: (context, index) {
                                    final s = ingredients[index];
                                    final isSelected =
                                        filter.ingredients.contains(s);

                                    return GestureDetector(
                                      onTap: () => _toggleIngredient(s),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.tealAccent
                                              : Colors.white.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: isSelected
                                                  ? Colors.tealAccent
                                                  : Colors.white24),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          s,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.white70,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SettingsContainer(
                          title: 'Dietary Preferences',
                          body: Column(
                            children: [
                              PreferenceWidget(
                                label: 'Gluten-free',
                                value: filter.isGlutenFree,
                                onChanged: (val) =>
                                    setState(() => filter.isGlutenFree = val),
                              ),
                              const Divider(color: Colors.white10),
                              PreferenceWidget(
                                label: 'Vegetarian',
                                value: filter.isVegetarian,
                                onChanged: (val) =>
                                    setState(() => filter.isVegetarian = val),
                              ),
                              const Divider(color: Colors.white10),
                              PreferenceWidget(
                                label: 'Lactose-free',
                                value: filter.isLactoseFree,
                                onChanged: (val) =>
                                    setState(() => filter.isLactoseFree = val),
                              ),
                            ],
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/filtered', arguments: filter);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Apply Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
