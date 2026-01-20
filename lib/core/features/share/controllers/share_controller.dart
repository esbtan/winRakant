import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_rakant/core/result/result.dart';
import 'package:win_rakant/providers.dart';
import '../state/share_state.dart';

class ShareController extends Notifier<ShareState> {
  @override
  ShareState build() => const ShareState();

  Future<void> createLink(String parkingId, {int? expiresInMinutes}) async {
    state = state.copyWith(loading: true, error: null);

    final repo = ref.read(shareRepoProvider);
    final res = await repo.createPublicLink(
      parkingId: parkingId,
      expiresInMinutes: expiresInMinutes,
    );

    switch (res) {
      case Ok(value: final link):
        state = state.copyWith(loading: false, link: link);
      case Err(failure: final f):
        state = state.copyWith(loading: false, error: f.message);
    }
  }

  void clearLink() {
    state = state.copyWith(link: null, error: null);
  }
}

final shareControllerProvider = NotifierProvider<ShareController, ShareState>(
  ShareController.new,
);
