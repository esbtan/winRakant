import 'package:flutter/material.dart';
import 'package:win_rakant/data/models/car_model.dart';
import 'package:win_rakant/l10n/app_localizations.dart';

class EditVehicleDraft {
  final String nickname;
  final String? plateNumber;
  final String vehicleType;

  const EditVehicleDraft({
    required this.nickname,
    this.plateNumber,
    required this.vehicleType,
  });
}

class EditVehicleDialog extends StatefulWidget {
  final Car car;
  const EditVehicleDialog({super.key, required this.car});

  @override
  State<EditVehicleDialog> createState() => _EditVehicleDialogState();
}

class _EditVehicleDialogState extends State<EditVehicleDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nicknameCtrl;
  late final TextEditingController _plateCtrl;
  late String _vehicleType;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController(text: widget.car.nickname);
    _plateCtrl = TextEditingController(text: widget.car.plateNumber ?? '');
    _vehicleType = widget.car.vehicleType;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      EditVehicleDraft(
        nickname: _nicknameCtrl.text.trim(),
        plateNumber: _plateCtrl.text.trim().isEmpty
            ? null
            : _plateCtrl.text.trim(),
        vehicleType: _vehicleType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: const Text('Edit Vehicle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _vehicleType,
              items: const [
                DropdownMenuItem(value: 'car', child: Text('🚗 Car')),
                DropdownMenuItem(
                  value: 'motorcycle',
                  child: Text('🏍️ Motorcycle'),
                ),
                DropdownMenuItem(value: 'scooter', child: Text('🛵 Scooter')),
              ],
              onChanged: (v) => setState(() => _vehicleType = v ?? 'car'),
              decoration: const InputDecoration(labelText: 'Vehicle type'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nicknameCtrl,
              decoration: const InputDecoration(labelText: 'Nickname'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _plateCtrl,
              decoration: const InputDecoration(
                labelText: 'Plate number (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
