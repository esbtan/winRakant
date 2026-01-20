import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSource {
  SupabaseClient get client => Supabase.instance.client;
  String? get uid => client.auth.currentUser?.id;
}
