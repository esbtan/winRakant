import 'package:flutter/material.dart';
import 'package:win_rakant/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car_filled,
              size: 64,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 12),
            const Text(
              'لا توجد سيارات حتى الآن',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'أضف أول سيارة لتبدأ.',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('إضافة أول سيارة'),
            ),
          ],
        ),
      ),
    );
  }
}
