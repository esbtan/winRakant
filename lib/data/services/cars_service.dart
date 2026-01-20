import '../../core/supabase/supabase_client.dart';

class CarsService {
  Future<String> createCar({
    required String nickname,
    String? plateNumber,
  }) async {
    final uid = SB.uid;
    if (uid == null) throw Exception("Not authenticated");

    final car = await SB.client
        .from('cars')
        .insert({
          'created_by': uid,
          'nickname': nickname,
          'plate_number': plateNumber,
        })
        .select('id')
        .single();

    final carId = car['id'] as String;

    await SB.client.from('car_members').insert({
      'car_id': carId,
      'user_id': uid,
      'role': 'owner',
      'added_by': uid,
    });

    return carId;
  }

  Future<List<Map<String, dynamic>>> getMyCars() async {
    final res = await SB.client
        .from('cars')
        .select('id,nickname,plate_number,make,model,color,year,created_at');
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> addMemberToCar({
    required String carId,
    required String userId,
    String role = 'viewer',
  }) async {
    final uid = SB.uid;
    if (uid == null) throw Exception("Not authenticated");

    await SB.client.from('car_members').insert({
      'car_id': carId,
      'user_id': userId,
      'role': role,
      'added_by': uid,
    });
  }
}
