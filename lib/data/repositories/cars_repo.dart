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

    return (data as List).map((e) => Car.fromMap(e)).toList();
  }

  Future<void> createCar({
    required String nickname,
    String? plateNumber,
    required String vehicleType,
    String? make,
    String? model,
    String? color,
    int? year,
  }) async {
    final uid = source.client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    final inserted = await source.client
        .from('cars')
        .insert({
          'created_by': uid,
          'nickname': nickname,
          'plate_number': plateNumber,
          'vehicle_type': vehicleType,
          'make': make,
          'model': model,
          'color': color,
          'year': year,
        })
        .select('id')
        .single();

    final carId = inserted['id'] as String;

    await source.client.from('car_members').insert({
      'car_id': carId,
      'user_id': uid,
      'role': 'owner',
      'added_by': uid,
    });
  }

  // ✅ UPDATE
  Future<void> updateCar({
    required String carId,
    required String nickname,
    String? plateNumber,
    required String vehicleType,
  }) async {
    await source.client
        .from('cars')
        .update({
          'nickname': nickname,
          'plate_number': plateNumber,
          'vehicle_type': vehicleType,
        })
        .eq('id', carId);
  }

  // ✅ DELETE
  Future<void> deleteCar(String carId) async {
    await source.client.from('cars').delete().eq('id', carId);
  }
}
