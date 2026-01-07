import 'package:get/get.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeController extends GetxController {
  /// Bottom navigation current index
  final RxInt currentIndex = 0.obs;

  /// Navigation controller for PersistentTabView
  final PersistentTabController tabController = PersistentTabController(
    initialIndex: 0,
  );

  /// Promotional banner current page index
  final RxInt currentBannerIndex = 0.obs;

  /// Banner images
  final List<String> bannerImages = const [
    'lib/assets/images/about farmer iamge.png',
    'lib/assets/images/about farmer iamge.png',
    'lib/assets/images/about farmer iamge.png',
    'lib/assets/images/about farmer iamge.png',
  ];

  void onBottomNavChanged(int index) {
    currentIndex.value = index;
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  void jumpToTab(int index) {
    tabController.jumpToTab(index);
    onBottomNavChanged(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
