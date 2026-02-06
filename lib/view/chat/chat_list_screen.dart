import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import 'chat_screen.dart';
import '../../services/api_service.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1B834F)),
        ),
      );
    }

    return FutureBuilder<bool>(
      future: Get.find<ApiService>().isGuest(),
      builder: (context, snapshot) {
        final isGuest = snapshot.data ?? false;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Center(
              child: GestureDetector(
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    // If it's the root tab, jump to Home tab (index 0)
                    try {
                      final homeController = Get.find<HomeController>();
                      homeController.jumpToTab(0);
                    } catch (e) {
                      // Fallback to standard back if controller not found
                      Get.back();
                    }
                  }
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B834F), // Green filled
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            title: Text(
              l10n.chat,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: isGuest ? () => _showLoginRequiredDialog(context) : null,
            behavior: HitTestBehavior.opaque,
            child: IgnorePointer(
              ignoring: isGuest,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 12),
                          Icon(Icons.search, color: Colors.grey, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Obx(() {
                      if (controller.isFetchingThreads.value &&
                          controller.threads.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.threads.isEmpty) {
                        return const Center(
                          child: Text(
                            'No chats yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchThreads();
                        },
                        color: const Color(0xFF1B834F),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.threads.length,
                          itemBuilder: (context, index) {
                            final thread = controller.threads[index];
                            return _ChatListItem(thread: thread);
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
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
}

class _ChatListItem extends StatelessWidget {
  final ChatThread thread;

  const _ChatListItem({required this.thread});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Obx(() {
      final String pId = thread.productId;
      final cached = ChatThread.productCache[pId];

      final String currentTitle =
          (cached?.name ?? '').isNotEmpty ? cached!.name : thread.title;

      final String cachedImage = cached?.image ?? '';
      final String currentAvatar =
          cachedImage.isNotEmpty ? cachedImage : thread.avatarPath;

      final bool hasUnread = thread.unreadCount > 0;

      return InkWell(
        onTap: () => Get.to(() => const ChatScreen(), arguments: thread),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child:
                    currentAvatar.isNotEmpty && currentAvatar.startsWith('http')
                        ? Image.network(
                          currentAvatar,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 48,
                                height: 48,
                                color: Colors.grey.shade100,
                                child: const Icon(
                                  Icons.inventory_2,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.inventory_2,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            currentTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  hasUnread ? FontWeight.bold : FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.more_vert,
                              size: 16,
                              color: Colors.black,
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                controller.deleteThread(thread.id);
                              } else if (value == 'report') {
                                _showReportDialog(context, controller);
                              }
                            },
                            itemBuilder: (context) {
                              final l10n = AppLocalizations.of(context)!;
                              return [
                                PopupMenuItem(
                                  value: 'report',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.flag_outlined, size: 18),
                                      const SizedBox(width: 8),
                                      Text(l10n.reportChat),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(l10n.deleteChat),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            thread.lastMessage.isEmpty
                                ? 'No messages yet'
                                : thread.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  hasUnread
                                      ? Colors.black87
                                      : Colors.grey.shade800,
                              fontWeight:
                                  hasUnread
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              thread.timeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    hasUnread
                                        ? const Color(0xFF1B834F)
                                        : Colors.grey.shade700,
                                fontWeight:
                                    hasUnread
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            if (hasUnread)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1B834F),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  thread.unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showReportDialog(BuildContext context, ChatController controller) {
    final TextEditingController reasonController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              l10n.reportChat,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reason),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: l10n.pleaseEnterReason,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B834F)),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final reason = reasonController.text.trim();
                  if (reason.isEmpty) {
                    Get.snackbar(
                      l10n.error,
                      l10n.pleaseEnterReason,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                    return;
                  }
                  Navigator.pop(context); // Close dialog

                  final success = await controller.reportChatApi(
                    thread.id,
                    reason,
                  );

                  if (success) {
                    Get.snackbar(
                      l10n.success,
                      l10n.adReported,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF1B834F),
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  } else {
                    Get.snackbar(
                      l10n.error,
                      l10n.failedReport,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B834F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.submit,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
