import '../../core/supabase/supabase_client.dart';

class ParkingsService {
  Future<String> createParking({
    required String carId,
    required double lat,
    required double lng,
    String? title,
    String? notes,
    String? address,
    bool isCurrent = true,
  }) async {
    final uid = SB.uid;
    if (uid == null) throw Exception("Not authenticated");

    // لو عايز تقفل القديمة قبل الجديدة:
    if (isCurrent) {
      await SB.client
          .from('parkings')
          .update({
            'is_current': false,
            'ended_at': DateTime.now().toIso8601String(),
          })
          .eq('car_id', carId)
          .eq('is_current', true);
    }

    final res = await SB.client
        .from('parkings')
        .insert({
          'car_id': carId,
          'parked_by': uid,
          'lat': lat,
          'lng': lng,
          'title': title,
          'notes': notes,
          'address': address,
          'is_current': isCurrent,
        })
        .select('id')
        .single();

    return res['id'] as String;
  }

  Future<List<Map<String, dynamic>>> getHistory(String carId) async {
    final res = await SB.client
        .from('parkings')
        .select('id,title,notes,lat,lng,address,parked_at,is_current')
        .eq('car_id', carId)
        .order('parked_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<Map<String, dynamic>?> getCurrentParking(String carId) async {
    final res = await SB.client
        .from('parkings')
        .select('id,title,lat,lng,address,parked_at')
        .eq('car_id', carId)
        .eq('is_current', true)
        .maybeSingle();

    return res == null ? null : Map<String, dynamic>.from(res);
  }
}
