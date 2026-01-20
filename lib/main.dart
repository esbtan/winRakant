import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers.dart';
import 'core/features/auth/ui/login_screen.dart';
import 'core/features/cars/ui/cars_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ervpaoghipqyimdptfkl.supabase.co',
    anonKey: 'sb_publishable_SLesyxt3EtbhbE66fbXKvQ_uzuKBUL8',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authSessionProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: sessionAsync.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
        data: (session) =>
            session == null ? const LoginScreen() : const CarsScreen(),
      ),
    );
  }
}
