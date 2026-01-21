import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_rakant/providers.dart';
import '../state/cars_state.dart';
import 'package:win_rakant/data/models/car_model.dart';

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
    required String vehicleType,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await ref
          .read(carsRepoProvider)
          .createCar(
            nickname: nickname,
            plateNumber: plateNumber,
            vehicleType: vehicleType,
          );
      await loadCars();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ✅ EDIT (Optimistic)
  Future<void> updateCar({
    required String carId,
    required String nickname,
    String? plateNumber,
    required String vehicleType,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      await ref
          .read(carsRepoProvider)
          .updateCar(
            carId: carId,
            nickname: nickname,
            plateNumber: plateNumber,
            vehicleType: vehicleType,
          );

      await loadCars();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ✅ DELETE (Optimistic)
  Future<void> deleteCar(Car car) async {
    state = state.copyWith(error: null);

    final prevCars = state.cars;
    state = state.copyWith(
      cars: prevCars.where((c) => c.id != car.id).toList(),
    );

    try {
      await ref.read(carsRepoProvider).deleteCar(car.id);
    } catch (e) {
      state = state.copyWith(cars: prevCars, error: e.toString());
    }
  }
}

final carsControllerProvider = NotifierProvider<CarsController, CarsState>(
  CarsController.new,
);
