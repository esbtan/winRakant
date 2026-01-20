import '../../core/errors/failure.dart';
import '../../core/result/result.dart';
import '../models/parking.dart';
import '../sources/supabase_source.dart';

class ParkingsRepo {
  final SupabaseSource sb;
  ParkingsRepo(this.sb);

  Failure _mapError(Object e) => Failure(e.toString());

  Future<Result<String>> createParking({
    required String carId,
    required double lat,
    required double lng,
    String? title,
    String? address,
    bool isCurrent = true,
  }) async {
    try {
      final uid = sb.uid;
      if (uid == null) return Err(Failure('Not authenticated'));

      // اغلق current القديمة (اختياري)
      if (isCurrent) {
        await sb.client
            .from('parkings')
            .update({
              'is_current': false,
              'ended_at': DateTime.now().toIso8601String(),
            })
            .eq('car_id', carId)
            .eq('is_current', true);
      }

      final row = await sb.client
          .from('parkings')
          .insert({
            'car_id': carId,
            'parked_by': uid,
            'lat': lat,
            'lng': lng,
            'title': title,
            'address': address,
            'is_current': isCurrent,
          })
          .select('id')
          .single();

      return Ok(row['id'] as String);
    } catch (e) {
      return Err(_mapError(e));
    }
  }

  Future<Result<Parking?>> getCurrentParking(String carId) async {
    try {
      final row = await sb.client
          .from('parkings')
          .select('id,car_id,lat,lng,title,address,parked_at,is_current')
          .eq('car_id', carId)
          .eq('is_current', true)
          .maybeSingle();

      if (row == null) return const Ok(null);
      return Ok(Parking.fromMap(row));
    } catch (e) {
      return Err(_mapError(e));
    }
  }

  Future<Result<List<Parking>>> getHistory(String carId) async {
    try {
      final rows = await sb.client
          .from('parkings')
          .select('id,car_id,lat,lng,title,address,parked_at,is_current')
          .eq('car_id', carId)
          .order('parked_at', ascending: false);

      final list = (rows as List)
          .map((r) => Parking.fromMap(r as Map<String, dynamic>))
          .toList();
      return Ok(list);
    } catch (e) {
      return Err(_mapError(e));
    }
  }
}
