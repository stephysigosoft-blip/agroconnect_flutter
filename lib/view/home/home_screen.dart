import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import 'home_content.dart';
import '../chat/chat_list_screen.dart';
import '../sell/sell_item_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    Get.put(ProductController());
    Get.put(WishlistController());
    Get.put(ChatController());
    final l10n = AppLocalizations.of(context)!;

    return PersistentTabView(
      context,
      controller: controller.tabController,
      screens: _buildScreens(),
      items: _buildNavBarItems(l10n),
      backgroundColor: Colors.white,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      navBarHeight: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      navBarStyle: NavBarStyle.style16,
      onItemSelected: (index) {
        if (index == 2) {
          // Check verification status (static for now)
          _showVerificationPopup(context, controller);
        } else {
          controller.onBottomNavChanged(index);
        }
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
                  child: const Icon(
                    Icons.badge_outlined,
                    size: 40,
                    color: Colors.black87,
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
                        onPressed: () => Get.back(),
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
                        onPressed: () {
                          Get.back(); // Close dialog
                          Get.toNamed('/identityVerification');
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

  List<PersistentBottomNavBarItem> _buildNavBarItems(AppLocalizations l10n) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),

        title: l10n.home,
        activeColorPrimary: const Color(0xFF1B834F),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Obx(() {
          final count = Get.find<ChatController>().unreadCount.value;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.chat_bubble_outline),
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
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
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
        }),
        title: l10n.chat,
        activeColorPrimary: const Color(0xFF1B834F),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: const Color(0xFF1B834F),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
        title: l10n.sell,
        activeColorPrimary: const Color(0xFF1B834F),
        inactiveColorPrimary: const Color(0xFF1B834F),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite_border),
        title: l10n.wishlist,
        activeColorPrimary: const Color(0xFF1B834F),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        title: l10n.profile,
        activeColorPrimary: const Color(0xFF1B834F),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
