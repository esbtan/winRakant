import '../../core/errors/failure.dart';
import '../../core/result/result.dart';
import '../models/parking.dart';
import '../models/share_link.dart';
import '../sources/supabase_source.dart';

class ShareRepo {
  final SupabaseSource sb;
  ShareRepo(this.sb);

  Failure _mapError(Object e) => Failure(e.toString());

  Future<Result<ShareLink>> createPublicLink({
    required String parkingId,
    int? expiresInMinutes,
  }) async {
    try {
      final res = await sb.client.rpc(
        'create_share_link',
        params: {
          'p_parking_id': parkingId,
          'p_expires_in_minutes': expiresInMinutes,
        },
      );

      final row = (res as List).first as Map<String, dynamic>;
      return Ok(ShareLink.fromMap(row));
    } catch (e) {
      return Err(_mapError(e));
    }
  }

  Future<Result<Parking?>> getPublicSharedParking(String token) async {
    try {
      final res = await sb.client.rpc(
        'get_shared_parking',
        params: {'p_token': token},
      );
      final list = (res as List);
      if (list.isEmpty) return const Ok(null);

      // RPC بيرجع حقول أقل (بس كفاية للعرض)
      final m = list.first as Map<String, dynamic>;
      // نحولها لParking بشكل مبسط (carId قد لا يرجع في RPC حسب سكيمتك)
      return Ok(
        Parking(
          id: m['parking_id'] as String,
          carId: 'public',
          lat: (m['lat'] as num).toDouble(),
          lng: (m['lng'] as num).toDouble(),
          title: m['title'] as String?,
          address: m['address'] as String?,
          parkedAt: DateTime.parse(m['parked_at'] as String),
          isCurrent: true,
        ),
      );
    } catch (e) {
      return Err(_mapError(e));
    }
  }
}
