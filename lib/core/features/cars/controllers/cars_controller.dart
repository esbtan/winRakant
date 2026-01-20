import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_rakant/providers.dart';
import '../state/cars_state.dart';

class CarsController extends Notifier<CarsState> {
  @override
  CarsState build() => const CarsState();

  Future<void> loadCars() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final cars = await ref.read(carsRepoProvider).getMyCars();
      state = state.copyWith(loading: false, cars: cars);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> createCar({
    required String nickname,
    String? plateNumber,
    String? make,
    String? model,
    String? color,
    int? year,
  }) async {
    try {
      await ref
          .read(carsRepoProvider)
          .createCar(
            nickname: nickname,
            plateNumber: plateNumber,
            make: make,
            model: model,
            color: color,
            year: year,
          );

      await loadCars();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow; // ✅ لازم
    }
  }
}

final carsControllerProvider = NotifierProvider<CarsController, CarsState>(
  CarsController.new,
);
