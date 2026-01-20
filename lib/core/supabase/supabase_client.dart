import 'package:supabase_flutter/supabase_flutter.dart';

class SB {
  static SupabaseClient get client => Supabase.instance.client;
  static String? get uid => client.auth.currentUser?.id;
}
