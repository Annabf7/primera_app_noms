import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:primera_app_noms/person_detail.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<PeopleList> createState() => PeopleListState();
}

// 🔹 Enum per definir el tipus de filtre actiu (tots, dones o homes)
enum GenderFilter { all, women, men }

class PeopleListState extends State<PeopleList> {
  final _suggestions = <String>[];
  final _favorites = <String>{};

  // ✅ Fem servir el paquet amb la zona catalana
  final _randomNames = RandomNames(Zone.catalonia);

  // 🔹 Filtre actiu (per defecte, tots)
  GenderFilter _filter = GenderFilter.all;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  // 🔹 Inicialitza SharedPreferences i carrega els favorits guardats
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final storedFavs = _prefs.getStringList('favorites') ?? [];
    _favorites.addAll(storedFavs);

    // Precarrega 20 noms inicials
    for (var j = 0; j < 20; j++) {
      _suggestions.add(_generateName());
    }

    if (mounted) setState(() {});
  }

  // 🔹 Desa l’estat actual de favorits al disc
  Future<void> _saveFavorites() async {
    await _prefs.setStringList('favorites', _favorites.toList());
  }

  // 🔄 Recarrega els favorits des del disc (per sincronitzar amb canvis externs)
  Future<void> _reloadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final latest = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites
        ..clear()
        ..addAll(latest);
    });
  }

  // 🔁 Mètode públic per refrescar favorits des d’altres pantalles (com FavoritesPage)
  Future<void> refreshFavoritesFromDisk() async {
    await _reloadFavoritesFromPrefs();
  }

  // 🔹 Genera un nom segons el filtre seleccionat
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

  // 🔹 Quan es canvia el filtre, es regenera la llista
  void _applyFilter(GenderFilter newFilter) {
    if (_filter == newFilter) return;
    setState(() {
      _filter = newFilter;
      _suggestions.clear();
      for (var j = 0; j < 20; j++) {
        _suggestions.add(_generateName());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ───────────────────── Barra de filtres ─────────────────────
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

        // ───────────────────── Graella “infinita” ────────────────────
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 🔹 nombre de columnes
              crossAxisSpacing: 12, // espai horitzontal entre columnes
              mainAxisSpacing: 12, // espai vertical entre files
              childAspectRatio: 6, // relació ample-altura
            ),
            itemBuilder: (context, i) {
              // Assegurem que hi hagi prou elements per a l’índex demanat
              while (i >= _suggestions.length) {
                // afegeix en blocs per eficiència
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
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.indigo
                              : Colors.grey.shade500,
                        ),
                        onPressed: () async {
                          // 1) sincronitza amb el que hi ha desat al disc (evita “revivals”)
                          await _reloadFavoritesFromPrefs();

                          // 2) aplica el canvi sobre l’estat ja sincronitzat
                          final isFavoriteNow = _favorites.contains(name);
                          setState(() {
                            if (isFavoriteNow) {
                              _favorites.remove(name);
                            } else {
                              _favorites.add(name);
                            }
                          });

                          // 3) persisteix
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
