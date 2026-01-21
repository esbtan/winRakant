import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dialogs/edit_vehicle_dialog.dart';
import 'package:win_rakant/data/models/car_model.dart';
import 'package:win_rakant/providers.dart';

class VehicleList extends ConsumerWidget {
  final List<Car> cars;
  const VehicleList({super.key, required this.cars});

  IconData _iconFor(String type) {
    switch (type) {
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'scooter':
        return Icons.electric_scooter;
      default:
        return Icons.directions_car;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'motorcycle':
        return '🏍️ Motorcycle';
      case 'scooter':
        return '🛵 Scooter';
      default:
        return '🚗 Car';
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Car car,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف المركبة؟'),
        content: Text('متأكد إنك عايز تحذف "${car.nickname}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok == true) {
      // ✅ لازم تكون موجودة في controller
      await ref.read(carsControllerProvider.notifier).deleteCar(car);
    }
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Car car) async {
    final draft = await showDialog<EditVehicleDraft>(
      context: context,
      builder: (_) => EditVehicleDialog(car: car),
    );

    if (draft == null) return;

    await ref
        .read(carsControllerProvider.notifier)
        .updateCar(
          carId: car.id,
          nickname: draft.nickname,
          plateNumber: draft.plateNumber,
          vehicleType: draft.vehicleType,
        );
  }

  void _openDetails(BuildContext context, Car car) {
    // ✅ دي صفحة المستقبل (خريطة/شير/مكان الركنة)
    // دلوقتي خليها Placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open details for: ${car.nickname}')),
    );

    // لاحقًا:
    // Navigator.push(context, MaterialPageRoute(builder: (_) => CarDetailsScreen(carId: car.id)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: cars.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final car = cars[i];
        final icon = _iconFor(car.vehicleType);

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            onTap: () => _openDetails(context, car),
            leading: CircleAvatar(child: Icon(icon)),
            title: Text(
              car.nickname,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              [
                _typeLabel(car.vehicleType),
                if ((car.plateNumber ?? '').isNotEmpty)
                  'Plate: ${car.plateNumber}',
              ].join(' • '),
            ),

            // ✅ 3 نقاط: Edit / Delete
            trailing: PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'edit') {
                  await _edit(context, ref, car);
                } else if (v == 'delete') {
                  await _confirmDelete(context, ref, car);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 10),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
