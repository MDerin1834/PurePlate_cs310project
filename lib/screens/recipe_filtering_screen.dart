import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pure_plate/models/filter.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/data/ingredients.dart';

// 1. YARDIMCI WIDGET: AYAR KUTUSU (GLASS EFEKTLİ)
class SettingsContainer extends StatelessWidget {
  final Widget body;
  final String title;
  const SettingsContainer({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent, // Başlıkları vurguladık
                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                ),
              ),
              SizedBox(height: 12),
              body,
            ],
          ),
        ),
      ),
    );
  }
}

// 2. YARDIMCI WIDGET: TERCİH SWITCH'İ
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
            activeTrackColor: Colors.tealAccent,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.white10,
          ),
        ],
      ),
    );
  }
}

class RecipeFilteringScreen extends StatefulWidget {
  const RecipeFilteringScreen({super.key});

  @override
  State<RecipeFilteringScreen> createState() => _RecipeFilteringScreenState();
}

class _RecipeFilteringScreenState extends State<RecipeFilteringScreen> {
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
      pageIndex: 1, // Recipes sekmesi aktif

      // Floating Action Button Tasarımı
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        icon: Icon(Icons.check),
        label: Text(
          'Apply Filters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/filtered', arguments: filter);
        },
      ),

      body: Stack(
        children: [
          // 1. KATMAN: Arkaplan
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
            ),
          ),
          // 2. KATMAN: Karartma
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
          // 3. KATMAN: İçerik
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Filter Recipes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48), // Dengelemek için boşluk
                    ],
                  ),
                  SizedBox(height: 30),

                  // MAX CALORIES
                  SettingsContainer(
                    title: 'Max Calories',
                    body: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('100 kcal', style: TextStyle(color: Colors.white54)),
                            Text(
                              '${filter.maxCalories} kcal',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text('2000 kcal', style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.tealAccent,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.white,
                            overlayColor: Colors.tealAccent.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: filter.maxCalories.toDouble(),
                            min: 100,
                            max: 2000,
                            onChanged: (val) =>
                                setState(() => filter.maxCalories = val.round()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // COOKING TIME
                  SettingsContainer(
                    title: 'Max Cooking Time',
                    body: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1 min', style: TextStyle(color: Colors.white54)),
                            Text(
                              '${filter.cookingTime} min',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text('60 min', style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.tealAccent,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: filter.cookingTime.toDouble(),
                            min: 1,
                            max: 60,
                            onChanged: (val) =>
                                setState(() => filter.cookingTime = val.round()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // INGREDIENTS
                  SettingsContainer(
                    title: 'Ingredients',
                    body: Column(
                      children: [
                        // Arama Çubuğu
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Search ingredients...',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search, color: Colors.tealAccent),
                              suffixIcon: IconButton(
                                onPressed: () => _controller.clear(),
                                icon: Icon(Icons.clear, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Malzeme Grid'i (Tasarımı iyileştirildi)
                        Container(
                          height: 200, // Biraz daha alan açtım
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: RawScrollbar(
                            thumbColor: Colors.tealAccent.withOpacity(0.5),
                            radius: Radius.circular(5),
                            child: GridView.builder(
                              padding: EdgeInsets.all(8),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5, // Yatay dikdörtgen oranı
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: ingredients.length,
                              itemBuilder: (context, index) {
                                final s = ingredients[index];
                                final isSelected = filter.ingredients.contains(s);

                                return GestureDetector(
                                  onTap: () => _toggleIngredient(s),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.tealAccent.withOpacity(0.8)
                                          : Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? Colors.tealAccent : Colors.white24,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        s,
                                        style: TextStyle(
                                          color: isSelected ? Colors.black : Colors.white,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // PREFERENCES
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
                        Divider(color: Colors.white12),
                        PreferenceWidget(
                          label: 'Vegetarian',
                          value: filter.isVegetarian,
                          onChanged: (val) =>
                              setState(() => filter.isVegetarian = val),
                        ),
                        Divider(color: Colors.white12),
                        PreferenceWidget(
                          label: 'Lactose-free',
                          value: filter.isLactoseFree,
                          onChanged: (val) =>
                              setState(() => filter.isLactoseFree = val),
                        ),
                      ],
                    ),
                  ),

                  // FAB'ın altında kalmaması için boşluk
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}