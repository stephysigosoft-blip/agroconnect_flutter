// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get selectLanguage => 'Sélectionnez votre langue préférée';

  @override
  String get continue_ => 'Continuer';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'Anglais';

  @override
  String get loginOrSignUp => 'Connexion ou Inscription';

  @override
  String get enterWhatsappNumber => 'Entrez votre numéro WhatsApp';

  @override
  String get otpVerification => 'Vérification OTP';

  @override
  String get otpSentMessage =>
      'Nous avons envoyé un code de vérification à votre WhatsApp';

  @override
  String resendCodeIn(int seconds) {
    return 'Renvoyer le code dans $seconds sec';
  }

  @override
  String get didntGetOtp => 'Vous n\'avez pas reçu l\'OTP?';

  @override
  String get resendOtp => 'Renvoyer l\'OTP';

  @override
  String get whatsYourName => 'Quel est votre nom?';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get done => 'Terminé';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte? Connexion';

  @override
  String get loginSuccessful => 'Connexion réussie!';

  @override
  String registrationSuccessful(String name) {
    return 'Inscription réussie! Bienvenue $name';
  }

  @override
  String get welcomeMessage =>
      'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.';

  @override
  String get guestLogin => 'Connexion invité';

  @override
  String get home => 'Accueil';

  @override
  String get chat => 'Chat';

  @override
  String get sell => 'Vendre';

  @override
  String get wishlist => 'Liste de souhaits';

  @override
  String get profile => 'Profil';

  @override
  String get categories => 'Catégories';

  @override
  String get recentlyAdded => 'Récemment ajouté';

  @override
  String get recommendationsForYou => 'Recommandations pour vous';

  @override
  String get grainsCereals => 'Céréales et grains';

  @override
  String get vegetables => 'Légumes';

  @override
  String get livestockMeat => 'Bétail et viande';

  @override
  String get poultryEggs => 'Volaille et œufs';

  @override
  String get aboutUs => 'À propos de nous NOTRE FERME QUI NOUS SOMMES';

  @override
  String available(String quantity) {
    return '$quantity Kg Disponible';
  }

  @override
  String pricePerKg(String price) {
    return '$price MRU / Kg';
  }

  @override
  String daysAgo(int days) {
    return 'Il y a $days jour';
  }
}
