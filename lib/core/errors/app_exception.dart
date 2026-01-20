import 'failure.dart';

class AppException implements Exception {
  final Failure failure;
  AppException(this.failure);

  @override
  String toString() => failure.toString();
}
