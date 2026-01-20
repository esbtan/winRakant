import 'package:win_rakant/data/models/parking.dart';

class ParkingState {
  final bool loading;
  final Parking? current;
  final List<Parking> history;
  final String? error;

  const ParkingState({
    this.loading = false,
    this.current,
    this.history = const [],
    this.error,
  });

  ParkingState copyWith({
    bool? loading,
    Parking? current,
    List<Parking>? history,
    String? error,
  }) {
    return ParkingState(
      loading: loading ?? this.loading,
      current: current ?? this.current,
      history: history ?? this.history,
      error: error,
    );
  }
}
