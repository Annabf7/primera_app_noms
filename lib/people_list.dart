import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:primera_app_noms/person_detail.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<PeopleList> createState() => PeopleListState();
}

// 🔹 Tipus de filtre
enum GenderFilter { all, women, men }

class PeopleListState extends State<PeopleList> {
  final _suggestions = <String>[];
  final _favorites = <String>{};

  // ✅ Noms catalans
  final _randomNames = RandomNames(Zone.catalonia);

  GenderFilter _filter = GenderFilter.all;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  // ─────────────────────────── Persistència ───────────────────────────
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final storedFavs = _prefs.getStringList('favorites') ?? [];
    _favorites.addAll(storedFavs);

    // Precarrega 20 noms
    for (var j = 0; j < 20; j++) {
      _suggestions.add(_generateName());
    }

    if (mounted) setState(() {});
  }

  Future<void> _saveFavorites() async {
    await _prefs.setStringList('favorites', _favorites.toList());
  }

  Future<void> _reloadFavoritesFromPrefs() async {
    final latest = _prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites
        ..clear()
        ..addAll(latest);
    });
  }

  /// 👈 cridable des d’altres pantalles (la fem servir en tornar de FavoritesPage)
  Future<void> refreshFavoritesFromDisk() => _reloadFavoritesFromPrefs();

  // ───────────────────────── Generació de noms ────────────────────────
  String _generateName() {
    switch (_filter) {
      case GenderFilter.women:
        return _randomNames.womanFullName();
      case GenderFilter.men:
        return _randomNames.manFullName();
      case GenderFilter.all:
        return _randomNames.fullName();
    }
  }

  void _applyFilter(GenderFilter newFilter) {
    if (_filter == newFilter) return;
    setState(() {
      _filter = newFilter;
      _suggestions
        ..clear()
        ..addAll(List.generate(20, (_) => _generateName()));
    });
  }

  // ───────────────────────────── UI ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de filtres
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: ToggleButtons(
            isSelected: [
              _filter == GenderFilter.all,
              _filter == GenderFilter.women,
              _filter == GenderFilter.men,
            ],
            onPressed: (index) {
              final chosen = [
                GenderFilter.all,
                GenderFilter.women,
                GenderFilter.men,
              ][index];
              _applyFilter(chosen);
            },
            borderRadius: BorderRadius.circular(10),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Tots'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Dona'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Home'),
              ),
            ],
          ),
        ),

        // Graella “infinita”
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 6,
            ),
            itemBuilder: (context, i) {
              // Assegura elements suficients
              while (i >= _suggestions.length) {
                for (var j = 0; j < 20; j++) {
                  _suggestions.add(_generateName());
                }
              }

              final name = _suggestions[i];
              final isFavorite = _favorites.contains(name);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: EdgeInsets.zero,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonDetailPage(name: name),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nom
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      ),

                      // Cor de favorits
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.indigo
                              : Colors.grey.shade500,
                        ),
                        onPressed: () async {
                          // 1) sincronitza amb disc (evita “revivals”)
                          await _reloadFavoritesFromPrefs();

                          // 2) aplica el canvi sobre l’estat sincronitzat
                          final isFavoriteNow = _favorites.contains(name);
                          setState(() {
                            if (isFavoriteNow) {
                              _favorites.remove(name);
                            } else {
                              _favorites.add(name);
                            }
                          });

                          // 3) desa
                          await _saveFavorites();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
