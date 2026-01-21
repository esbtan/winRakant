import 'package:flutter/material.dart';
import '../utils/vehicle_ui.dart';
import 'package:win_rakant/l10n/app_localizations.dart';

class CarDraft {
  final String nickname;
  final String? plateNumber;
  final String vehicleType; // car | motorcycle | scooter
  const CarDraft({
    required this.nickname,
    this.plateNumber,
    required this.vehicleType,
  });
}

class AddVehicleDialog extends StatefulWidget {
  const AddVehicleDialog({super.key});

  @override
  State<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final formKey = GlobalKey<FormState>();
  final nicknameCtrl = TextEditingController();
  final plateCtrl = TextEditingController();

  String vehicleType = 'car';

  @override
  void dispose() {
    nicknameCtrl.dispose();
    plateCtrl.dispose();
    super.dispose();
  }

  void cancel() => Navigator.of(context).pop(null);

  void ok() {
    if (!formKey.currentState!.validate()) return;

    final nickname = nicknameCtrl.text.trim();
    final plate = plateCtrl.text.trim();

    Navigator.of(context).pop(
      CarDraft(
        nickname: nickname,
        plateNumber: plate.isEmpty ? null : plate,
        vehicleType: vehicleType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: const Text('إضافة مركبة'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: vehicleType,
              items: const [
                DropdownMenuItem(value: 'car', child: Text('🚗 سيارة')),
                DropdownMenuItem(
                  value: 'motorcycle',
                  child: Text('🏍️ دراجة نارية'),
                ),
                DropdownMenuItem(value: 'scooter', child: Text('🛵 سكوتر')),
              ],
              onChanged: (v) => setState(() => vehicleType = v ?? 'car'),
              decoration: const InputDecoration(labelText: 'نوع المركبة *'),
            ),
            const SizedBox(height: 10),
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
        TextButton(onPressed: cancel, child: const Text('Cancel')),
        ElevatedButton.icon(
          onPressed: ok,
          icon: const Icon(Icons.check),
          label: const Text('OK'),
        ),
      ],
    );
  }
}
