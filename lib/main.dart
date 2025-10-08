import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primera_app_noms/people_list.dart';
import 'package:primera_app_noms/favorites_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _mode = (_mode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // 🔹 Mateixa tipografia i estil base per als dos modes
  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseText = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],

      textTheme: baseText.copyWith(
        bodyMedium: TextStyle(
          fontSize: 18,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.indigo.shade400 : Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 3,
        toolbarHeight: 140,
        titleTextStyle: GoogleFonts.bebasNeue(
          textStyle: const TextStyle(
            fontSize: 42,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 2,
        margin: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de noms aleatoris',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: _HomeScreen(
        isDark: _mode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  _HomeScreen({required this.isDark, required this.onToggleTheme})
    : _peopleListKey = GlobalKey<PeopleListState>();

  final GlobalKey<PeopleListState> _peopleListKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPhone = size.width < 600;

    // 🔹 AppBar més baix a mòbil i títol responsive
    final appBarHeight = isPhone ? 96.0 : 140.0;
    final titleSize = (size.width * 0.06).clamp(26.0, 40.0);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: SizedBox(height: 8),
        ),
        leadingWidth: 48,
        leading: const SizedBox(width: 48),
        title: Text(
          'Generador de noms',
          style: Theme.of(
            context,
          ).appBarTheme.titleTextStyle?.copyWith(fontSize: titleSize),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: isDark ? 'Mode clar' : 'Mode fosc',
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 24,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(6),
                ),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Veure favorits',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritesPage()),
                    );
                    await _peopleListKey.currentState
                        ?.refreshFavoritesFromDisk();
                  },
                  icon: const Icon(Icons.favorite_border, size: 24),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(6),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: PeopleList(key: _peopleListKey),
    );
  }
}
