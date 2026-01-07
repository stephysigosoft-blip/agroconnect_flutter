import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// Title for language selection modal
  ///
  /// In en, this message translates to:
  /// **'Select Your Preferred Language'**
  String get selectLanguage;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get arabic;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Section title for login/register
  ///
  /// In en, this message translates to:
  /// **'Login or Sign up'**
  String get loginOrSignUp;

  /// Placeholder for phone number input
  ///
  /// In en, this message translates to:
  /// **'Enter your whatsapp number'**
  String get enterWhatsappNumber;

  /// OTP verification screen title
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// Message shown after OTP is sent
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to your WhatsApp'**
  String get otpSentMessage;

  /// Resend code timer message
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds} sec'**
  String resendCodeIn(int seconds);

  /// Text before resend OTP link
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the OTP?'**
  String get didntGetOtp;

  /// Resend OTP link text
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Name input screen title
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get whatsYourName;

  /// Placeholder for name input
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Link to register screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAccount;

  /// Link to login screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// Success message after login
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Success message after registration
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Welcome {name}'**
  String registrationSuccessful(String name);

  /// Welcome/description text on login/register screens
  ///
  /// In en, this message translates to:
  /// **'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.'**
  String get welcomeMessage;

  /// Guest login button text
  ///
  /// In en, this message translates to:
  /// **'Guest Login'**
  String get guestLogin;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @recommendationsForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommendations for You'**
  String get recommendationsForYou;

  /// No description provided for @grainsCereals.
  ///
  /// In en, this message translates to:
  /// **'Grains & Cereals'**
  String get grainsCereals;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @livestockMeat.
  ///
  /// In en, this message translates to:
  /// **'Livestock & Meat'**
  String get livestockMeat;

  /// No description provided for @poultryEggs.
  ///
  /// In en, this message translates to:
  /// **'Poultry & Eggs'**
  String get poultryEggs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us OUR FARM WHO WE ARE'**
  String get aboutUs;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'{quantity} Kg Available'**
  String available(String quantity);

  /// No description provided for @pricePerKg.
  ///
  /// In en, this message translates to:
  /// **'{price} MRU / Kg'**
  String pricePerKg(String price);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} day ago'**
  String daysAgo(int days);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
