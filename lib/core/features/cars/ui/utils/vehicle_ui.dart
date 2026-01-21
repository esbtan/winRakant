import 'package:flutter/material.dart';

String? validateNickname(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return 'من فضلك اكتب اسم للمركبة (Nickname)';
  if (s.length < 2) return 'الاسم قصير جدًا';
  return null;
}

String? validatePlate(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return null; // optional

  final ok = RegExp(r'^[A-Za-z0-9 -]{4,10}$');
  if (!ok.hasMatch(s)) {
    return 'رقم اللوحة غير صحيح (4–10 حروف/أرقام)';
  }
  return null;
}

IconData vehicleIcon(String vehicleType) {
  switch (vehicleType) {
    case 'motorcycle':
      return Icons.two_wheeler;
    case 'scooter':
      return Icons.electric_scooter;
    default:
      return Icons.directions_car;
  }
}
