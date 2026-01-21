import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_rakant/providers.dart';

import '../state/cars_state.dart';

import 'dialogs/add_vehicle_dialog.dart';
import 'widgets/vehicle_list.dart';
import 'widgets/empty_state.dart';
import 'widgets/loading_state.dart';
import 'widgets/error_state.dart';

import 'package:win_rakant/l10n/locale_controller.dart';
import 'package:win_rakant/l10n/app_localizations.dart';

class CarsScreen extends ConsumerStatefulWidget {
  const CarsScreen({super.key});

  @override
  ConsumerState<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends ConsumerState<CarsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(carsControllerProvider.notifier).loadCars(),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? Colors.red.shade700 : null,
        ),
      );
    });
  }

  Future<void> _addVehicleFlow() async {
    final t = AppLocalizations.of(context);

    final draft = await showDialog<CarDraft>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddVehicleDialog(),
    );

    if (!mounted || draft == null) return;

    await ref
        .read(carsControllerProvider.notifier)
        .createCar(
          nickname: draft.nickname,
          plateNumber: draft.plateNumber,
          vehicleType: draft.vehicleType,
        );

    final after = ref.read(carsControllerProvider);
    if (!mounted) return;

    if (after.error != null) {
      _showSnack('${t.saveFailed}: ${after.error}', isError: true);
    } else {
      _showSnack(t.vehicleAdded);
    }
  }

  Widget _buildBody(CarsState state) {
    final t = AppLocalizations.of(context);

    if (state.loading) {
      return CarsLoading(
        key: const ValueKey('loading'),
      ); // ✅ بدون const قبل CarsLoading
    }

    if (state.error != null) {
      return ErrorState(
        key: const ValueKey('error'),
        message: t.genericErrorWith(state.error!),
        onRetry: () => ref.read(carsControllerProvider.notifier).loadCars(),
      );
    }

    if (state.cars.isEmpty) {
      return EmptyState(key: const ValueKey('empty'), onAdd: _addVehicleFlow);
    }

    return VehicleList(key: const ValueKey('list'), cars: state.cars);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final CarsState state = ref.watch(carsControllerProvider);

    // ✅ Listen للأخطاء (مترجم) وآمن
    ref.listen<CarsState>(carsControllerProvider, (prev, next) {
      final prevErr = prev?.error;
      final nextErr = next.error;
      if (nextErr != null && nextErr != prevErr) {
        _showSnack(t.genericErrorWith(nextErr), isError: true);
      }
    });

    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myVehicles),
        actions: [
          IconButton(
            tooltip: t.refresh,
            onPressed: state.loading
                ? null
                : () => ref.read(carsControllerProvider.notifier).loadCars(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      ref.read(authServiceProvider).currentUser?.email ??
                          t.noEmail,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.loggedIn,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // ✅ Language Switch
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(t.language),
                subtitle: Text(
                  locale.languageCode == 'ar' ? t.arabic : t.english,
                ),
                trailing: Switch(
                  value: locale.languageCode == 'en',
                  onChanged: (isEn) {
                    final ctrl = ref.read(localeProvider.notifier);
                    if (isEn) {
                      ctrl.setEnglish();
                    } else {
                      ctrl.setArabic();
                    }
                  },
                ),
              ),

              const Spacer(),

              // ✅ Sign out
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(t.signOut),
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authServiceProvider).signOut();
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _buildBody(state),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.loading ? null : _addVehicleFlow,
        icon: const Icon(Icons.add),
        label: Text(t.addVehicle),
      ),
    );
  }
}
