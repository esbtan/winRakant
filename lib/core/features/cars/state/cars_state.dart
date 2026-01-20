import 'package:win_rakant/data/models/car_model.dart';

class CarsState {
  final bool loading;
  final String? error;
  final List<Car> cars;

  const CarsState({this.loading = false, this.error, this.cars = const []});

  CarsState copyWith({bool? loading, String? error, List<Car>? cars}) {
    return CarsState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      cars: cars ?? this.cars,
    );
  }
}
