import 'dart:ui'; // Blur efekti için gerekli
import 'package:flutter/material.dart';
import 'package:pure_plate/models/filter.dart';
import 'package:pure_plate/widgets/pureplate_app_scaffold.dart';
import 'package:pure_plate/widgets/recipe_tile_widget.dart';
import 'package:pure_plate/data/recipes.dart';

class FilteredRecipesScreen extends StatelessWidget {
  const FilteredRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Filter args = ModalRoute.of(context)!.settings.arguments as Filter;
    final filtered = recipes.where(args.matches).toList();

    return PurePlateAppScaffold(
      pageIndex: 1, // Recipes sekmesi aktif görünsün
      body: Stack(
        children: [
          // 1. KATMAN: Arkaplan Resmi (Home ile aynı)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1353',
              fit: BoxFit.cover,
            ),
          ),
          // 2. KATMAN: Karartma Gradyanı (Yazıların okunması için)
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER: Geri Butonu ve Başlık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Glassmorphism Geri Butonu
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'Back',
                        ),
                      ),
                      // Başlıklar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Filtered Recipes',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                            ),
                          ),
                          Text(
                            '${filtered.length} result(s) found',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.tealAccent, // Vurgu rengi
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // İÇERİK: Liste veya Boş Durum
                  Flexible(
                    fit: FlexFit.loose,
                    child: filtered.isEmpty
                        ? _buildEmptyState(context) // Boşsa özel tasarım
                        : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          // Kartların arkasına hafif bir cam efekti ekleyebiliriz veya
                          // RecipeTileWidget zaten kart yapısındaysa direkt kullanabiliriz.
                          child: Container(
                            // Eğer RecipeTileWidget şeffafsa bu container arkasını doldurur
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              // color: Colors.black.withOpacity(0.3), // İsteğe bağlı ekstra koyuluk
                            ),
                            child: RecipeTileWidget(
                              recipe: filtered[index],
                              isHorizontal: true, // Yatay kart yapısı (Resim solda, yazı sağda)
                            ),
                          ),
                        );
                      },
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

  // Boş Durum (Empty State) Tasarımı - Glassmorphism
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.manage_search, size: 60, color: Colors.white54),
                const SizedBox(height: 20),
                const Text(
                  'No recipes found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Try changing your filter criteria.',
                  style: TextStyle(color: Colors.white60),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.filter_list),
                  label: const Text(
                    'Refine Filters',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}