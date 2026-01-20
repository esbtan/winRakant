import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:win_rakant/data/sources/supabase_source.dart';
import 'package:win_rakant/data/repositories/cars_repo.dart';
import 'package:win_rakant/data/repositories/parkings_repo.dart';
import 'package:win_rakant/data/repositories/share_repo.dart';
import 'package:win_rakant/data/services/auth_service.dart';

// Exports (اختياري)
export 'package:win_rakant/core/features/cars/controllers/cars_controller.dart';
export 'package:win_rakant/core/features/share/controllers/share_controller.dart';

final supabaseSourceProvider = Provider((ref) => SupabaseSource());

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ✅ AuthService Provider (كان ناقص)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(supabaseClientProvider));
});

// ✅ Session stream فقط (ده اللي main.dart لازم يستخدمه)
final authSessionProvider = StreamProvider<Session?>((ref) {
  return ref.read(authServiceProvider).onSessionChange;
});

final carsRepoProvider = Provider(
  (ref) => CarsRepo(ref.read(supabaseSourceProvider)),
);

final parkingsRepoProvider = Provider(
  (ref) => ParkingsRepo(ref.read(supabaseSourceProvider)),
);

final shareRepoProvider = Provider(
  (ref) => ShareRepo(ref.read(supabaseSourceProvider)),
);
