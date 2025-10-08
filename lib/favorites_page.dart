import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // ──────────────────────── Carrega i desa favorits ────────────────────────
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.remove(name);
    });
    await prefs.setStringList('favorites', _favorites);
  }

  // ─────────────────────────────── UI PRINCIPAL ───────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: theme.appBarTheme.toolbarHeight,
        centerTitle: true,
        title: Text('Favorits', style: theme.appBarTheme.titleTextStyle),
      ),
      body: _favorites.isEmpty
          ? Stack(
              fit: StackFit.expand,
              children: [
                // 🌀 Animació Lottie ocupant tota la pantalla
                Lottie.asset(
                  'assets/animations/motion.json',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  repeat: true,
                ),

                // ✨ Capa semitransparent per donar contrast al text
                Container(color: Colors.black.withValues(alpha: 0.25)),

                // 📄 Text + botó superposats
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Encara no hi ha noms desats com a favorits',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: const [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent.withValues(
                            alpha: 0.8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text(
                          'Torna a la llista',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3,
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, i) {
                final name = _favorites[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔹 Nom favorit
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // 🔹 Botó eliminar
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.indigoAccent,
                          ),
                          tooltip: 'Eliminar dels favorits',
                          onPressed: () => _removeFavorite(name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
