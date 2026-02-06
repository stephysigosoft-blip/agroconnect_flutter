import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/subscription_controller.dart';
import '../../utils/snackbar_helper.dart';
import '../../services/api_service.dart';

import '../../controllers/my_ads_controller.dart';

import '../../controllers/home_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../utils/localization_helper.dart';
import '../../utils/api_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';
  String _userName = '';
  String _userPhone = '';
  String _userCountryCode = '';
  String _userImage = '';
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    Get.put(SubscriptionController());
    Get.put(MyAdsController());
    _loadCurrentLanguage();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload user data when screen becomes visible (e.g., after editing profile)
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? '';
      _userPhone = prefs.getString('user_phone') ?? '';
      _userCountryCode = prefs.getString('user_country_code') ?? '';
      _userImage = prefs.getString('user_image') ?? '';
      _isGuest = prefs.getBool('is_guest') ?? false;
    });

    // Fetch from API to sync
    try {
      final apiService = Get.find<ApiService>();
      final profileData = await apiService.getProfile();
      if (profileData != null && profileData['status'] == true) {
        final data = profileData['data'];
        final userData = data['user'];
        setState(() {
          _userName =
              userData['name_en'] ??
              userData['name_ar'] ??
              userData['name_fr'] ??
              '';
          _userPhone = userData['mobile'] ?? '';
          _userCountryCode = userData['country_code'] ?? '';
          String img = userData['image'] ?? '';
          if (img.isNotEmpty && !img.startsWith('http')) {
            img = '${ApiConstants.imageBaseUrl}$img';
          }
          _userImage = img;
        });
        // Update SharedPreferences
        await prefs.setString('user_name', _userName);
        await prefs.setString('user_phone', _userPhone);
        await prefs.setString('user_country_code', _userCountryCode);
        await prefs.setString('user_image', _userImage);
      }
    } catch (e) {
      // Ignore errors silently as per "no UI change" rule
    }
  }

  Future<void> _loadCurrentLanguage() async {
    final locale = await LocalizationHelper.loadLanguage();
    setState(() {
      _selectedLanguage = LocalizationHelper.getLanguageCodeFromLocale(locale);
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    final locale = LocalizationHelper.getLocaleFromLanguageCode(language);
    LocalizationHelper.saveLanguage(language);
    MyApp.of(context)?.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserData();
        },
        color: const Color(0xFF1B834F),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: GestureDetector(
            onTap: _isGuest ? () => _showLoginRequiredDialog(context) : null,
            behavior: HitTestBehavior.opaque,
            child: IgnorePointer(
              ignoring: _isGuest,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildUserInfo(),
                  const SizedBox(height: 24),
                  _buildSubscriptionCard(),
                  const SizedBox(height: 24),
                  _buildLanguageSelector(),
                  const SizedBox(height: 24),
                  _buildMenuList(),
                  const SizedBox(height: 24),
                  _buildSocialMediaIcons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Login Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'please login to access the application',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed('/languageSelection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B834F),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 220,
              width: double.infinity,
              color: const Color(
                0xFFD6ECE3,
              ), // Light mint green matched from image
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:
                                () => Get.find<HomeController>().jumpToTab(0),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B834F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.profile,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 35), // Balance the row
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50, // Moved up to overlap more
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child:
                              _userImage.isNotEmpty
                                  ? Image.network(
                                    _userImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                          child: Text(
                                            (_userName.isNotEmpty
                                                    ? _userName
                                                    : AppLocalizations.of(
                                                      context,
                                                    )!.guestUser)
                                                .characters
                                                .first
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                  )
                                  : Center(
                                    child: Text(
                                      (_userName.isNotEmpty
                                              ? _userName
                                              : AppLocalizations.of(
                                                context,
                                              )!.guestUser)
                                          .characters
                                          .first
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        // Navigate to Edit Profile and refresh on return
                        await Get.toNamed('/editProfile');
                        // Reload data after returning from edit screen
                        _loadUserData();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xFF1B834F),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          _userName.isNotEmpty
              ? _userName
              : AppLocalizations.of(context)!.guestUser,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final count = Get.find<MyAdsController>().activeAds.length;
          return Text(
            AppLocalizations.of(context)!.publishedAds(count),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1B834F),
              fontWeight: FontWeight.w600,
            ),
          );
        }),
        const SizedBox(height: 6),
        Text(
          '$_userCountryCode $_userPhone',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF39600), // Orange/Gold
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium, // Or similar crown icon
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.subscription,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.upgradeDescription,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE65100),
                  Color(0xFFFDD835),
                ], // Dark orange to yellow
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Obx(() {
              final controller = Get.find<SubscriptionController>();
              return ElevatedButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : () async {
                          await controller.fetchAllPackages();
                          Get.toNamed('/buyPackages');
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child:
                    controller.isLoading.value
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          AppLocalizations.of(context)!.upgrade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.changeLanguage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Light green background
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildLanguageOption(
                  AppLocalizations.of(context)!.french,
                  'Français',
                  _selectedLanguage == 'Français',
                ),
              ),
              Expanded(
                child: _buildLanguageOption(
                  AppLocalizations.of(context)!.english,
                  'English',
                  _selectedLanguage == 'English',
                ),
              ),
              Expanded(
                child: _buildLanguageOption(
                  AppLocalizations.of(context)!.arabic,
                  'عربي',
                  _selectedLanguage == 'عربي',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    String label,
    String languageCode,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => _changeLanguage(languageCode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B834F) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.grid_view,
            title: AppLocalizations.of(context)!.myAds,
            onTap: () => Get.toNamed('/myAds'),
          ),
          _buildMenuItem(
            icon: Icons.card_membership,
            title: AppLocalizations.of(context)!.myPackages,
            onTap: () async {
              final controller = Get.find<SubscriptionController>();
              await controller.fetchMyPackages();
              Get.toNamed('/myPackages');
            },
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: AppLocalizations.of(context)!.orders,
            onTap: () => Get.toNamed('/orders'),
          ),
          _buildMenuItem(
            icon: Icons.perm_identity,
            title: AppLocalizations.of(context)!.identityVerificationKyc,
            onTap: () => Get.toNamed('/identityVerification'),
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: AppLocalizations.of(context)!.settings,
            onTap: () => Get.toNamed('/settings'),
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context)!.aboutUs,
            onTap: () => Get.toNamed('/aboutUs'),
          ),
          _buildMenuItem(
            icon: Icons.chat_bubble_outline,
            title: AppLocalizations.of(context)!.helpSupport,
            onTap: () => Get.toNamed('/helpSupport'),
          ),
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: AppLocalizations.of(context)!.termsConditions,
            onTap: () => Get.toNamed('/termsConditions'),
          ),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            title: AppLocalizations.of(context)!.privacyPolicy,
            onTap: () => Get.toNamed('/privacyPolicy'),
          ),
          if (!_isGuest)
            _buildMenuItem(
              icon: Icons.logout,
              title: AppLocalizations.of(context)!.logout,
              onTap: _showLogoutDialog,
              isLogout: true,
              showChevron: false,
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    bool showChevron = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.red : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isLogout ? Colors.red : Colors.black87,
                  ),
                ),
              ),
              if (showChevron || (isLogout && false)) ...[
                // Logic handling
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ] else if (isLogout) ...[
                // No icon for logout based on image? Looking at image again.
                // Image shows logout with RED ARROW POINTING LEFT inside a circle outline?
                // No, image shows "Logout" with an icon that looks like a C with arrow pointing left.
                // let's use Icons.exit_to_app or similar but rotated?
                // Or just standard logout icon.
                // The image clearly shows a red logout icon on the LEFT.- [x] Integrate Remaining APIs
                // - [x] Update `ApiConstants` with all missing endpoints
                // - [x] Update `ApiService` with corresponding methods
                // - [/] Integrate Profile & KYC APIs
                // Is there a trailing icon?
                // Image: No chevron for logout.
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          'lib/assets/images/Icons/instagram.png',
          'https://www.instagram.com/',
        ),
        const SizedBox(width: 20),
        _buildSocialIcon(
          'lib/assets/images/Icons/facebook.png',
          'https://www.facebook.com/login.php/',
        ),
        const SizedBox(width: 20),
        _buildSocialIcon(
          'lib/assets/images/Icons/whatsapp.png',
          'https://web.whatsapp.com/', // Replace with actual number if needed
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        try {
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $url';
          }
        } catch (e) {
          SnackBarHelper.showError(
            AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.connectionError(e.toString()),
          );
        }
      },
      child: Image.asset(
        assetPath,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error, color: Colors.white, size: 20),
            ),
      ),
    );
  }

  void _showLogoutDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close Button (Top Right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pop(), // Reliable close
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Title
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Message
                  Text(
                    AppLocalizations.of(context)!.logoutConfirmation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      // No Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed:
                                () =>
                                    Navigator.of(
                                      context,
                                    ).pop(), // Reliable close
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1B834F)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.no,
                              style: const TextStyle(
                                color: Color(0xFF1B834F),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Logout Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close sheet first

                              // Call logout API
                              final apiService = Get.find<ApiService>();
                              await apiService.logout();

                              // Selective clear: Remove only auth and user-specific session data
                              final prefs =
                                  await SharedPreferences.getInstance();
                              // This preserves global settings like language and user-prefixed read status
                              await prefs.remove('auth_token');
                              await prefs.remove('user_id');
                              await prefs.remove('user_name');
                              await prefs.remove('user_phone');
                              await prefs.remove('user_country_code');
                              await prefs.remove('user_image');

                              // Navigate to language selection screen
                              Get.offAllNamed('/languageSelection');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B834F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.logout,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom-left, up a bit

    // Create a quadratic bezier curve
    var firstControlPoint = Offset(
      size.width / 2,
      size.height + 20,
    ); // Control point below the edge center
    var firstEndPoint = Offset(
      size.width,
      size.height - 50,
    ); // End point at bottom-right

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Up to top-right
    path.lineTo(0, 0); // Back to top-left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
