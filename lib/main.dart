import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:agroconnect_flutter/view/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

// Localizely SDK - To be implemented later (see LOCALIZELY_SETUP.md)
// import 'package:localizely_sdk/localizely_sdk.dart';
// import 'package:flutter_gen/gen_l10n/localizely_localizations.dart';

import 'view/splash/splash_screen.dart';
import 'view/onboarding/language_selection_screen.dart';
import 'view/register/phone_input_screen.dart';
import 'view/register/otp_verification_screen.dart';
import 'view/register/name_input_screen.dart';
import 'view/home/home_screen.dart';
import 'view/search/search_screen.dart';
import 'view/product/product_detail_screen.dart';
import 'view/chat/chat_list_screen.dart';
import 'view/chat/chat_screen.dart';
import 'view/profile/profile_screen.dart';
import 'view/profile/seller_profile_screen.dart';
import 'view/profile/identity_verification_screen.dart';
import 'view/sell/buy_packages_screen.dart';
import 'view/sell/my_packages_screen.dart';
import 'view/sell/ad_posted_success_screen.dart';
import 'view/orders/orders_screen.dart';
import 'view/sell/sell_item_screen.dart';
import 'view/settings/settings_screen.dart';
import 'view/profile/edit_profile_screen.dart';
import 'view/notifications/notifications_screen.dart';
import 'view/help/help_support_screen.dart';
import 'view/legal/terms_conditions_screen.dart';
import 'view/legal/privacy_policy_screen.dart';
import 'view/about/about_us_screen.dart';
import 'view/my_ads/my_ads_screen.dart';
import 'view/my_ads/ad_details_seller_screen.dart';
import 'view/my_ads/edit_item_screen.dart';
import 'view/my_ads/ad_reposted_success_screen.dart';
import 'utils/localization_helper.dart';
import 'services/api_service.dart';
// Localizely config - To be used when implementing Localizely (see LOCALIZELY_SETUP.md)
// import 'config/localizely_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Localizely SDK initialization - To be implemented later (see LOCALIZELY_SETUP.md)
  // Uncomment and configure when ready:
  // Localizely.init('<SDK_TOKEN>', '<DISTRIBUTION_ID>');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ApiService());
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await LocalizationHelper.loadLanguage();
    setState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });

    // Save language preference
    final languageCode = LocalizationHelper.getLanguageCodeFromLocale(locale);
    await LocalizationHelper.saveLanguage(languageCode);

    // Localizely: Update translations when language changes (To be implemented later)
    // await Localizely.updateTranslations();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SAIMPEX AGRO Connect Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      locale: _locale,
      localizationsDelegates: const [
        // Localizely SDK delegates - To be enabled later (see LOCALIZELY_SETUP.md)
        // ...LocalizelyLocalizations.localizationsDelegates,
        // Flutter generated localizations (default)
        AppLocalizations.delegate,
        // Flutter built-in localizations
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Localizely: Uncomment after setup (see LOCALIZELY_SETUP.md)
      // supportedLocales: LocalizelyLocalizations.supportedLocales.isNotEmpty
      //     ? LocalizelyLocalizations.supportedLocales
      //     : AppLocalizations.supportedLocales,
      // Enable RTL for Arabic
      builder: (context, child) {
        final textDirection =
            _locale.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr;
        return Directionality(
          textDirection: textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(
          name: '/languageSelection',
          page: () => const LanguageSelectionScreen(),
        ),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/search', page: () => const SearchScreen()),
        GetPage(name: '/product', page: () => const ProductDetailScreen()),
        GetPage(name: '/chatList', page: () => const ChatListScreen()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/orders', page: () => const OrdersScreen()),
        GetPage(name: '/sell', page: () => const SellItemScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/editProfile', page: () => const EditProfileScreen()),
        GetPage(
          name: '/notifications',
          page: () => const NotificationsScreen(),
        ),
        GetPage(name: '/helpSupport', page: () => const HelpSupportScreen()),
        GetPage(
          name: '/termsConditions',
          page: () => const TermsConditionsScreen(),
        ),
        GetPage(
          name: '/privacyPolicy',
          page: () => const PrivacyPolicyScreen(),
        ),
        GetPage(name: '/aboutUs', page: () => const AboutUsScreen()),
        GetPage(name: '/myAds', page: () => const MyAdsScreen()),
        GetPage(
          name: '/sellerProfile',
          page: () => const SellerProfileScreen(),
        ),
        GetPage(
          name: '/identityVerification',
          page: () => const IdentityVerificationScreen(),
        ),
        GetPage(name: '/buyPackages', page: () => const BuyPackagesScreen()),
        GetPage(name: '/myPackages', page: () => const MyPackagesScreen()),
        GetPage(
          name: '/adPostedSuccess',
          page: () => const AdPostedSuccessScreen(),
        ),
        GetPage(
          name: '/adDetailsSeller',
          page: () => const AdDetailsSellerScreen(),
        ),
        GetPage(name: '/editItem', page: () => const EditItemScreen()),
        GetPage(
          name: '/adRepostedSuccess',
          page: () => const AdRepostedSuccessScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterPhoneInputScreen(),
        ),
        GetPage(name: '/wishlist', page: () => const WishlistScreen()),
        GetPage(
          name: '/register/otp',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return RegisterOtpVerificationScreen(
              phoneNumber: args['phoneNumber'] as String,
              countryCode: args['countryCode'] as String,
              mobileNumber: args['mobileNumber'] as String,
            );
          },
        ),
        GetPage(
          name: '/register/name',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return RegisterNameInputScreen(
              phoneNumber: args['phoneNumber'] as String,
              countryCode: args['countryCode'] as String? ?? '+222',
            );
          },
        ),
      ],
    );
  }
}
