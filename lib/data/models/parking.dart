import 'package:equatable/equatable.dart';

class Parking extends Equatable {
  final String id;
  final String carId;
  final double lat;
  final double lng;
  final String? title;
  final String? address;
  final DateTime parkedAt;
  final bool isCurrent;

  const Parking({
    required this.id,
    required this.carId,
    required this.lat,
    required this.lng,
    required this.parkedAt,
    required this.isCurrent,
    this.title,
    this.address,
  });

  factory Parking.fromMap(Map<String, dynamic> m) => Parking(
    id: m['id'] as String,
    carId: m['car_id'] as String,
    lat: (m['lat'] as num).toDouble(),
    lng: (m['lng'] as num).toDouble(),
    title: m['title'] as String?,
    address: m['address'] as String?,
    parkedAt: DateTime.parse(m['parked_at'] as String),
    isCurrent: (m['is_current'] ?? false) as bool,
  );

  @override
  List<Object?> get props => [
    id,
    carId,
    lat,
    lng,
    title,
    address,
    parkedAt,
    isCurrent,
  ];
}
