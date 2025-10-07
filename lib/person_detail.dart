import 'package:flutter/material.dart';

class PersonDetailPage extends StatelessWidget {
  final String name;
  const PersonDetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    // Neteja i assegura un nom “segur”
    final safeName = (name).trim();
    final initial = safeName.isEmpty ? '?' : safeName.substring(0, 1);

    return Scaffold(
      appBar: AppBar(
        // 🔹 mateixa alçada i estil global
        toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight,
        centerTitle: true,
        title: Text(
          safeName.isEmpty ? 'Sense nom' : safeName,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              child: Text(initial, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 12),
            Text(
              safeName.isEmpty ? '—' : safeName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              'Detall de la persona generada',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
