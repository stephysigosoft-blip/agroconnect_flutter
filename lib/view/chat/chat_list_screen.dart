import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    final l10n = AppLocalizations.of(context)!;

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
      body: Column(
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
              if (controller.threads.isEmpty) {
                return const Center(
                  child: Text(
                    'No chats yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.threads.length,
                itemBuilder: (context, index) {
                  final thread = controller.threads[index];
                  return _ChatListItem(thread: thread);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatThread thread;

  const _ChatListItem({required this.thread});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return InkWell(
      onTap: () => Get.toNamed('/chat', arguments: thread),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                thread.avatarPath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
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
                      Text(
                        thread.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            // width: 1,
                          ),
                        ),
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: Colors.black,
                          ),
                          onSelected: (value) {
                            if (value == 'delete') {
                              controller.deleteThread(thread.id);
                            } else if (value == 'report') {
                              // TODO: implement report
                            }
                          },
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: 'report',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.flag_outlined, size: 18),
                                      SizedBox(width: 8),
                                      Text('Report Chat'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete_outline, size: 18),
                                      SizedBox(width: 8),
                                      Text('Delete Chat'),
                                    ],
                                  ),
                                ),
                              ],
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
                          thread.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        thread.timeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
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
  }
}
