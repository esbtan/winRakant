import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:win_rakant/core/result/result.dart';
import 'package:win_rakant/providers.dart';
import 'package:win_rakant/core/features/parking/state/parking_state.dart';

class ParkingController extends StateNotifier<ParkingState> {
  ParkingController(this.ref) : super(const ParkingState());

  final Ref ref;

  Future<void> loadCurrent(String carId) async {
    state = state.copyWith(loading: true, error: null);

    final repo = ref.read(parkingsRepoProvider);
    final res = await repo.getCurrentParking(carId);

    switch (res) {
      case Ok(value: final current):
        state = state.copyWith(loading: false, current: current);
      case Err(failure: final f):
        state = state.copyWith(loading: false, error: f.message);
    }
  }

  Future<void> loadHistory(String carId) async {
    state = state.copyWith(loading: true, error: null);

    final repo = ref.read(parkingsRepoProvider);
    final res = await repo.getHistory(carId);

    switch (res) {
      case Ok(value: final list):
        state = state.copyWith(loading: false, history: list);
      case Err(failure: final f):
        state = state.copyWith(loading: false, error: f.message);
    }
  }

  Future<void> saveParking({
    required String carId,
    required double lat,
    required double lng,
    String? title,
    String? address,
  }) async {
    state = state.copyWith(loading: true, error: null);

    final repo = ref.read(parkingsRepoProvider);
    final res = await repo.createParking(
      carId: carId,
      lat: lat,
      lng: lng,
      title: title,
      address: address,
      isCurrent: true,
    );

    switch (res) {
      case Ok():
        await loadCurrent(carId);
        await loadHistory(carId);
      case Err(failure: final f):
        state = state.copyWith(loading: false, error: f.message);
    }
  }
}

final parkingControllerProvider =
    StateNotifierProvider<ParkingController, ParkingState>((ref) {
      return ParkingController(ref);
    });
