import 'package:flutter/material.dart';
import 'package:win_rakant/l10n/app_localizations.dart';

class CarsLoading extends StatelessWidget {
  const CarsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Container(
        height: 74,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
