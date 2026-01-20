import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String id;
  final String nickname;
  final String? plateNumber;

  const Car({required this.id, required this.nickname, this.plateNumber});

  factory Car.fromMap(Map<String, dynamic> m) => Car(
    id: m['id'] as String,
    nickname: (m['nickname'] ?? '') as String,
    plateNumber: m['plate_number'] as String?,
  );

  @override
  List<Object?> get props => [id, nickname, plateNumber];
}
