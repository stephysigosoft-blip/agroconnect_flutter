// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get selectLanguage => 'اختر لغتك المفضلة';

  @override
  String get continue_ => 'متابعة';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'English';

  @override
  String get loginOrSignUp => 'تسجيل الدخول أو التسجيل';

  @override
  String get enterWhatsappNumber => 'أدخل رقم الواتساب الخاص بك';

  @override
  String get otpVerification => 'التحقق من رمز OTP';

  @override
  String get otpSentMessage => 'لقد أرسلنا رمز التحقق إلى واتسابك';

  @override
  String resendCodeIn(int seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get didntGetOtp => 'لم تستلم رمز OTP؟';

  @override
  String get resendOtp => 'إعادة إرسال رمز OTP';

  @override
  String get whatsYourName => 'ما هو اسمك؟';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get done => 'تم';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ سجل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح!';

  @override
  String registrationSuccessful(String name) {
    return 'تم التسجيل بنجاح! مرحباً $name';
  }

  @override
  String get welcomeMessage =>
      'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.';

  @override
  String get guestLogin => 'تسجيل الدخول كضيف';

  @override
  String get home => 'الرئيسية';

  @override
  String get chat => 'الدردشة';

  @override
  String get sell => 'بيع';

  @override
  String get wishlist => 'قائمة الأمنيات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get categories => 'الفئات';

  @override
  String get recentlyAdded => 'المضاف حديثاً';

  @override
  String get recommendationsForYou => 'التوصيات لك';

  @override
  String get grainsCereals => 'الحبوب والحنطة';

  @override
  String get vegetables => 'الخضروات';

  @override
  String get livestockMeat => 'الماشية واللحوم';

  @override
  String get poultryEggs => 'الدواجن والبيض';

  @override
  String get aboutUs => 'من نحن مزرعتنا من نحن';

  @override
  String available(String quantity) {
    return '$quantity كجم متاح';
  }

  @override
  String pricePerKg(String price) {
    return '$price أوقية / كجم';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }
}
