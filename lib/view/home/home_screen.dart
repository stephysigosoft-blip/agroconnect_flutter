import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../controllers/subscription_controller.dart';
import 'home_content.dart';
import '../chat/chat_list_screen.dart';
import '../sell/sell_item_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../profile/profile_screen.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    Get.put(ProductController());
    Get.put(WishlistController());
    Get.put(ChatController());
    final subscriptionController = Get.put(SubscriptionController());
    subscriptionController.fetchMyPackages().then((_) {
      if (mounted && subscriptionController.myPackages.isEmpty) {
        _showNoPackageDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(backgroundColor: Colors.white);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _buildScreens(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) async {
              controller.onBottomNavChanged(index);

              if (index == 2) {
                _showVerificationPopup(context, controller);
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF188246),
            unselectedItemColor: Colors.black,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: ImageIcon(
                    AssetImage('lib/assets/images/Icons/Bottom home.png'),
                    size: 24,
                  ),
                ),
                label: l10n.home,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _ChatIconBadge(controller: controller),
                ),
                label: l10n.chat,
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: ImageIcon(
                    AssetImage('lib/assets/images/Icons/Bottom sell.png'),
                    size: 24,
                  ),
                ),
                label: l10n.sell,
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: ImageIcon(
                    AssetImage('lib/assets/images/Icons/Bottom wishlist.png'),
                    size: 24,
                  ),
                ),
                label: l10n.wishlist,
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: ImageIcon(
                    AssetImage('lib/assets/images/Icons/Bottom profile.png'),
                    size: 24,
                  ),
                ),
                label: l10n.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoPackageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow navigation/closing
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
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Active Plan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),
                const Text(
                  'You currently have no active packages. Please purchase a package to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed('/buyPackages');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Buy Package',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  void _showVerificationPopup(BuildContext context, HomeController controller) {
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
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'lib/assets/images/Icons/Identity verification.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verify your identity to sell',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'We need to confirm your identity before you can post ads. This helps keep the marketplace safe. It only takes a minute.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final isGuest =
                              await Get.find<ApiService>().isGuest();
                          if (isGuest) {
                            _showLoginRequiredDialog(context);
                          } else {
                            Get.back();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Color(0xFF1B834F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF1B834F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final isGuest =
                              await Get.find<ApiService>().isGuest();
                          if (isGuest) {
                            _showLoginRequiredDialog(context);
                          } else {
                            Get.back(); // Close dialog
                            Get.toNamed('/identityVerification');
                          }
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
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeContent(),
      const ChatListScreen(),
      const SellItemScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];
  }
}

class _ChatIconBadge extends StatelessWidget {
  final HomeController controller;
  const _ChatIconBadge({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int count = 0;
      try {
        if (Get.isRegistered<ChatController>()) {
          count = Get.find<ChatController>().unreadCount.value;
        }
      } catch (e) {
        debugPrint('⚠️ Chat Badge Error: $e');
      }

      return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const ImageIcon(
            AssetImage('lib/assets/images/Icons/Bottom chat.png'),
            size: 24,
          ),
          if (count > 0)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
