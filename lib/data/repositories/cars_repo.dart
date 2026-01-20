import '../models/car_model.dart';
import '../sources/supabase_source.dart';

class CarsRepo {
  final SupabaseSource source;
  CarsRepo(this.source);

  Future<List<Car>> getMyCars() async {
    final data = await source.client
        .from('cars')
        .select()
        .order('created_at', ascending: false);

    final cars = (data as List).map((e) => Car.fromMap(e)).toList();
    return cars;
  }

  Future<void> createCar({
    required String nickname,
    String? plateNumber,
    String? make,
    String? model,
    String? color,
    int? year,
  }) async {
    final uid = source.client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    // 1) insert car
    final inserted = await source.client
        .from('cars')
        .insert({
          'created_by': uid,
          'nickname': nickname,
          'plate_number': plateNumber,
          'make': make,
          'model': model,
          'color': color,
          'year': year,
        })
        .select('id')
        .single();

    final carId = inserted['id'] as String;

    // 2) add owner membership
    await source.client.from('car_members').insert({
      'car_id': carId,
      'user_id': uid,
      'role': 'owner',
      'added_by': uid,
    });
  }
}
