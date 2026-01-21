import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleController extends Notifier<Locale> {
  static const Locale ar = Locale('ar');
  static const Locale en = Locale('en');

  @override
  Locale build() => ar; // ✅ default Arabic

  void setArabic() => state = ar;
  void setEnglish() => state = en;

  void toggle() => state = (state.languageCode == 'ar') ? en : ar;
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
