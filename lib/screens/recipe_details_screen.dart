import 'dart:ui'; // Blur efekti için
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/providers/favourites_provider.dart';
import 'package:pure_plate/providers/scheduled_provider.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/providers/meal_log_provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {

    // Provider'ı dinle
    final favouritesProvider = context.watch<FavouritesProvider>();
    final favourites = favouritesProvider.favourites;

    // Favori durumunu kontrol et
    final isFavorite = favourites.contains(recipe.name);

    return PurePlateAppScaffold(
      pageIndex: 1,
      body: Stack(
        children: [
          // 1. KATMAN: Arkaplan Resmi
          Positioned.fill(
            child: Image.network(
              recipe.imageURL.isNotEmpty
                  ? recipe.imageURL
                  : 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          // 2. KATMAN: Karartma (Overlay)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.8],
                ),
              ),
            ),
          ),

          // 3. KATMAN: İçerik
          SafeArea(
            child: Column(
              children: [
                // HEADER (Geri Dön ve Favori Butonları)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                      _buildGlassButton(
                        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                        onPressed: () async {
                          if (isFavorite) {
                            await favouritesProvider.deleteFavourite(recipeId: recipe.name);
                          } else {
                            await favouritesProvider.addFavourite(recipe.name);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Başlık
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Bilgi Kutucukları
                        Row(
                          children: [
                            _buildInfoChip(
                              icon: Icons.local_fire_department,
                              label: '${recipe.calories} kcal',
                              color: Colors.orangeAccent,
                            ),
                            const SizedBox(width: 10),
                            _buildInfoChip(
                              icon: Icons.timer,
                              label: '${recipe.cookingTime} min',
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Diyet Etiketleri
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (recipe.isVegetarian)
                              _buildDietTag('Vegetarian', Icons.eco, Colors.greenAccent),
                            if (recipe.isLactoseFree)
                              _buildDietTag('Lactose-Free', Icons.water_drop, Colors.lightBlueAccent),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // MALZEMELER
                        _buildSectionContainer(
                          title: 'Ingredients',
                          icon: Icons.shopping_basket,
                          content: recipe.ingredients.isEmpty
                              ? const Text('No ingredients listed', style: TextStyle(color: Colors.white54))
                              : Column(
                            children: recipe.ingredients.map((ingredient) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      ingredient,
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TALİMATLAR
                        _buildSectionContainer(
                          title: 'Instructions',
                          icon: Icons.menu_book,
                          content: Text(
                            recipe.instructions.isEmpty
                                ? 'No instructions provided'
                                : recipe.instructions,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // AKSİYON BUTONLARI
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.tealAccent,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 5,
                                ),
                                onPressed: () async {
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
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    Navigator.pushNamed(context, '/records');
                                  }
                                },
                                icon: const Icon(Icons.add_circle_outline),
                                label: const Text('Add to Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.white30),
                                  ),
                                ),
                                onPressed: () => _showScheduleDialog(context),
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
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

  // --- YARDIMCI WIDGET'LAR ---

  Widget _buildGlassButton({required IconData icon, required VoidCallback onPressed, Color color = Colors.white}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDietTag(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required IconData icon, required Widget content}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.tealAccent, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              content,
            ],
          ),
        ),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Schedule Meal', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select date and time for this meal:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) => Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(primary: Colors.tealAccent, onPrimary: Colors.black, surface: Colors.grey),
                    ),
                    child: child!,
                  ),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) => Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(primary: Colors.tealAccent, onPrimary: Colors.black, surface: Colors.grey),
                      ),
                      child: child!,
                    ),
                  );
                  if (time != null) {
                    Navigator.pop(context);
                    context.read<ScheduleProvider>().addToSchedule(recipe, date);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('📅 Meal scheduled for ${date.day}/${date.month} at ${time.format(context)}'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Pick Date & Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}