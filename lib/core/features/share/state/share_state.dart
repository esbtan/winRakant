import 'package:win_rakant/data/models/share_link.dart';

class ShareState {
  final bool loading;
  final ShareLink? link;
  final String? error;

  const ShareState({this.loading = false, this.link, this.error});

  ShareState copyWith({bool? loading, ShareLink? link, String? error}) {
    return ShareState(
      loading: loading ?? this.loading,
      link: link ?? this.link,
      error: error,
    );
  }
}
