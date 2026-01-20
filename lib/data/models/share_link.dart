import 'package:equatable/equatable.dart';

class ShareLink extends Equatable {
  final String token;
  final String urlPath;
  final DateTime? expiresAt;

  const ShareLink({required this.token, required this.urlPath, this.expiresAt});

  factory ShareLink.fromMap(Map<String, dynamic> m) => ShareLink(
    token: m['token'] as String,
    urlPath: m['url_path'] as String,
    expiresAt: m['expires_at'] == null
        ? null
        : DateTime.parse(m['expires_at'] as String),
  );

  @override
  List<Object?> get props => [token, urlPath, expiresAt];
}
