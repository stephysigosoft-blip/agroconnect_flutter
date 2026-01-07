import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
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
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildNotificationCard(
            message:
                'Suspendisse urna metus, porttitor nec lacinia in, fermentum eu nisl. Ut imperdiet mattis justo.',
            time: '10:00 AM',
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            message:
                'Suspendisse urna metus, porttitor nec lacinia in, fermentum eu nisl. Ut imperdiet mattis justo.',
            time: '10:00 AM',
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            message:
                'Suspendisse urna metus, porttitor nec lacinia in, fermentum eu nisl. Ut imperdiet mattis justo.',
            time: '10:00 AM',
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            message:
                'Suspendisse urna metus, porttitor nec lacinia in, fermentum eu nisl. Ut imperdiet mattis justo.',
            time: '10:00 AM',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String message,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
