import '../../core/supabase/supabase_client.dart';

class ShareService {
  Future<Map<String, dynamic>> createPublicShareLink({
    required String parkingId,
    int? expiresInMinutes,
  }) async {
    final res = await SB.client.rpc(
      'create_share_link',
      params: {
        'p_parking_id': parkingId,
        'p_expires_in_minutes': expiresInMinutes,
      },
    );

    // RPC بيرجع row
    final row = (res as List).first as Map<String, dynamic>;
    return row;
  }

  Future<Map<String, dynamic>?> getSharedParking(String token) async {
    final res = await SB.client.rpc(
      'get_shared_parking',
      params: {'p_token': token},
    );

    final list = (res as List);
    if (list.isEmpty) return null;
    return Map<String, dynamic>.from(list.first);
  }
}
