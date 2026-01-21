import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isAr => locale.languageCode == 'ar';

  // -------- Common
  String get appTitle => isAr ? 'وين راكنت' : 'Win Rakant';
  String get ok => isAr ? 'موافق' : 'OK';
  String get cancel => isAr ? 'إلغاء' : 'Cancel';
  String get save => isAr ? 'حفظ' : 'Save';
  String get delete => isAr ? 'حذف' : 'Delete';
  String get edit => isAr ? 'تعديل' : 'Edit';
  String get refresh => isAr ? 'تحديث' : 'Refresh';

  // -------- Drawer / Profile
  String get noEmail => isAr ? 'لا يوجد بريد إلكتروني' : 'No email';
  String get loggedIn => isAr ? 'تم تسجيل الدخول' : 'Logged in';
  String get signOut => isAr ? 'تسجيل الخروج' : 'Sign Out';

  // -------- Language
  String get language => isAr ? 'اللغة' : 'Language';
  String get arabic => isAr ? 'العربية' : 'Arabic';
  String get english => isAr ? 'الإنجليزية' : 'English';

  // -------- Vehicles
  String get myVehicles => isAr ? 'مركباتي' : 'My Vehicles';
  String get addVehicle => isAr ? 'إضافة مركبة' : 'Add Vehicle';
  String get vehicleAdded => isAr ? 'تمت إضافة المركبة ✅' : 'Vehicle added ✅';

  String get saveFailed =>
      isAr ? 'فشل الحفظ، حاول مرة أخرى' : 'Save failed, try again';

  String genericErrorWith(String msg) => isAr ? 'حدث خطأ: $msg' : 'Error: $msg';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ar' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
