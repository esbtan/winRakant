import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_rakant/providers.dart';

String? validateNickname(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return 'من فضلك اكتب اسم للسيارة (Nickname)';
  if (s.length < 2) return 'الاسم قصير جدًا';
  return null;
}

String? validatePlate(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return null; // optional

  // يسمح بحروف/أرقام/شرطة/مسافة (زي: ABC-1234 أو 5555)
  final ok = RegExp(r'^[A-Za-z0-9 -]{4,10}$');
  if (!ok.hasMatch(s)) {
    return 'رقم اللوحة غير صحيح (4–10 حروف/أرقام)';
  }
  return null;
}

// ✅ DTO صغير للداتا الراجعة من الديالوج
class _CarDraft {
  final String nickname;
  final String? plateNumber;
  const _CarDraft({required this.nickname, this.plateNumber});
}

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

  // ✅ SnackBar آمن (بعد أي navigation/pop)
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

  // ✅ الديالوج يرجع الداتا فقط
  Future<void> _showAddCarDialog() async {
    final result = await showDialog<_CarDraft>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _AddCarDialog(),
    );

    if (!mounted || result == null) return; // cancel

    // مفيش داعي نعمل try/catch لو الكونترولر بيكتب الخطأ في state
    await ref
        .read(carsControllerProvider.notifier)
        .createCar(nickname: result.nickname, plateNumber: result.plateNumber);

    // ✅ لو حصل خطأ فعلاً هيتسجل في state.error
    final after = ref.read(carsControllerProvider);
    if (after.error != null) {
      _showSnack('حصل خطأ أثناء الحفظ: ${after.error}', isError: true);
      return;
    }

    _showSnack('تمت إضافة السيارة ✅');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(carsControllerProvider);

    // ✅ لو في error جديد يظهر كـ SnackBar (بدون ما يبوظ UI)
    ref.listen(carsControllerProvider, (prev, next) {
      final prevErr = prev?.error;
      final nextErr = next.error;
      if (nextErr != null && nextErr != prevErr) {
        _showSnack('Error: $nextErr', isError: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cars'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
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
                          'No email',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Logged in',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
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
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _buildBody(state),
      ),
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: state.loading ? 0.95 : 1,
        child: FloatingActionButton.extended(
          onPressed: state.loading ? null : _showAddCarDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Car'),
        ),
      ),
    );
  }

  Widget _buildBody(dynamic state) {
    if (state.loading) {
      return const _CarsLoading();
    }

    if (state.cars.isEmpty) {
      return _EmptyState(onAdd: _showAddCarDialog);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: state.cars.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final car = state.cars[i];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 180 + (i * 35)),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, (1 - v) * 10),
              child: child,
            ),
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.directions_car)),
              title: Text(
                car.nickname,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                [
                  if ((car.plateNumber ?? '').isNotEmpty)
                    'Plate: ${car.plateNumber}',
                  if ((car.make ?? '').isNotEmpty ||
                      (car.model ?? '').isNotEmpty)
                    '${car.make ?? ''} ${car.model ?? ''}'.trim(),
                  if ((car.color ?? '').isNotEmpty) 'Color: ${car.color}',
                  if (car.year != null) 'Year: ${car.year}',
                ].where((e) => e.isNotEmpty).join(' • '),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddCarDialog extends StatefulWidget {
  const _AddCarDialog();

  @override
  State<_AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<_AddCarDialog> {
  final formKey = GlobalKey<FormState>();
  final nicknameCtrl = TextEditingController();
  final plateCtrl = TextEditingController();

  @override
  void dispose() {
    nicknameCtrl.dispose();
    plateCtrl.dispose();
    super.dispose();
  }

  void _onCancel() => Navigator.of(context).pop(null);

  void _onOk() {
    if (!formKey.currentState!.validate()) return;

    final nickname = nicknameCtrl.text.trim();
    final plate = plateCtrl.text.trim();

    Navigator.of(context).pop(
      _CarDraft(nickname: nickname, plateNumber: plate.isEmpty ? null : plate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة سيارة'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nicknameCtrl,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateNickname,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nickname *',
                hintText: 'مثال: سيارتي / My BMW',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: plateCtrl,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validatePlate,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Plate Number (اختياري)',
                hintText: 'مثال: 5555 أو ABC-1234',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _onCancel, child: const Text('Cancel')),
        ElevatedButton.icon(
          onPressed: _onOk,
          icon: const Icon(Icons.check),
          label: const Text('OK'),
        ),
      ],
    );
  }
}

class _CarsLoading extends StatelessWidget {
  const _CarsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Container(
        height: 74,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car_filled,
              size: 64,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 12),
            const Text(
              'لا توجد سيارات حتى الآن',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'أضف أول سيارة لتبدأ.',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('إضافة أول سيارة'),
            ),
          ],
        ),
      ),
    );
  }
}
