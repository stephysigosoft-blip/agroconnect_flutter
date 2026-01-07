// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select Your Preferred Language';

  @override
  String get continue_ => 'Continue';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'English';

  @override
  String get loginOrSignUp => 'Login or Sign up';

  @override
  String get enterWhatsappNumber => 'Enter your whatsapp number';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get otpSentMessage =>
      'We\'ve sent a verification code to your WhatsApp';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code in $seconds sec';
  }

  @override
  String get didntGetOtp => 'Didn\'t get the OTP?';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get done => 'Done';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String registrationSuccessful(String name) {
    return 'Registration successful! Welcome $name';
  }

  @override
  String get welcomeMessage =>
      'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.';

  @override
  String get guestLogin => 'Guest Login';

  @override
  String get home => 'Home';

  @override
  String get chat => 'Chat';

  @override
  String get sell => 'Sell';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get profile => 'Profile';

  @override
  String get categories => 'Categories';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get recommendationsForYou => 'Recommendations for You';

  @override
  String get grainsCereals => 'Grains & Cereals';

  @override
  String get vegetables => 'Vegetables';

  @override
  String get livestockMeat => 'Livestock & Meat';

  @override
  String get poultryEggs => 'Poultry & Eggs';

  @override
  String get aboutUs => 'About us OUR FARM WHO WE ARE';

  @override
  String available(String quantity) {
    return '$quantity Kg Available';
  }

  @override
  String pricePerKg(String price) {
    return '$price MRU / Kg';
  }

  @override
  String daysAgo(int days) {
    return '$days day ago';
  }
}
