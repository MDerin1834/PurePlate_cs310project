import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/providers/recipe_provider.dart';
import 'package:pure_plate/providers/scheduled_provider.dart';
import 'package:pure_plate/screens/recipe_details_screen.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';

class ScheduledRecipesScreen extends StatelessWidget {
  const ScheduledRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'ı dinle (watch kullanarak değişiklikleri takip et)
    final recipeProvider = context.watch<RecipeProvider>();
    final scheduleProvider = context.watch<ScheduleProvider>();
    final scheduledRecipesIDs = scheduleProvider.scheduledRecipes;

    final scheduledRecipes = recipeProvider.recipes.where((r) {
      for (final ids in scheduledRecipesIDs) {
        if (r.name == ids.recipeId) return true; // TODO: use r.id instead of r.name
      }

      return false;
    }).toList();

    return PurePlateAppScaffold(
      pageIndex: 1, // Alt menüde hangi ikonun aktif olacağını belirler
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212), // Koyu arka plan
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst Başlık ve Geri Dön Butonu
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Meal Planner",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste Alanı
              Expanded(
                child: scheduledRecipes.isEmpty
                    ? _buildEmptyState() // Liste boşsa gösterilecek tasarım
                    : ListView.builder(
                  itemCount: scheduledRecipes.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final recipe = scheduledRecipes[index];
                    return _buildScheduledCard(context, recipe);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Liste boşken gösterilecek widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.calendar_today_outlined, color: Colors.white24, size: 80),
          SizedBox(height: 20),
          Text(
            "No meals planned yet!",
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Her bir planlanan yemek kartı
  Widget _buildScheduledCard(BuildContext context, recipe) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final scheduledRecipesIDs = scheduleProvider.scheduledRecipes;
    var scheduledId = "";

    for (final id in scheduledRecipesIDs) {
      if (recipe.name == id.recipeId) scheduledId = id.id;
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        // Kaydırınca Provider'dan sil
        context.read<ScheduleProvider>().removeFromSchedule(scheduledId);
      },
      child: Card(
        color: const Color(0xFF1E1E1E),
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              recipe.imageURL,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            recipe.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${recipe.calories} kcal",
            style: const TextStyle(color: Colors.tealAccent),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white38),
          onTap: () {
            // Tıklayınca tekrar detay sayfasına git
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailsScreen(recipe: recipe),
              ),
            );
          },
        ),
      ),
    );
  }
}