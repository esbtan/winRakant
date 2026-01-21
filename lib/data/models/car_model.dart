class Car {
  final String id;
  final String nickname;
  final String? plateNumber;
  final String vehicleType; // car | motorcycle | scooter
  final String? make;
  final String? model;
  final String? color;
  final int? year;

  Car({
    required this.id,
    required this.nickname,
    this.plateNumber,
    required this.vehicleType,
    this.make,
    this.model,
    this.color,
    this.year,
  });

  factory Car.fromMap(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      plateNumber: json['plate_number'] as String?,
      vehicleType: (json['vehicle_type'] as String?) ?? 'car',
      make: json['make'] as String?,
      model: json['model'] as String?,
      color: json['color'] as String?,
      year: json['year'] as int?,
    );
  }
}
