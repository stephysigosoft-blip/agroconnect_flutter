import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/chat_controller.dart';
import '../../utils/invoice_pdf_helper.dart';
import 'dispute_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Standard GetX way to ensure controller is available
    final ChatController chatController =
        Get.isRegistered<ChatController>()
            ? Get.find<ChatController>()
            : Get.put(ChatController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xfff9f9f9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
            'Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Color(0xFF1B834F),
                indicatorWeight: 3,
                tabs: [Tab(text: 'Bought'), Tab(text: 'Sold')],
              ),
            ),
          ),
        ),
        body: Obx(
          () => TabBarView(
            children: [
              _buildOrdersList(
                chatController,
                chatController.invoices.where((inv) => !inv.isSold).toList(),
                isBought: true,
              ),
              _buildOrdersList(
                chatController,
                chatController.invoices.where((inv) => inv.isSold).toList(),
                isBought: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(
    ChatController chatController,
    List<InvoiceRecord> invoices, {
    required bool isBought,
  }) {
    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'No orders yet',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: invoices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return _OrderCard(
          invoice: invoice,
          isBought: isBought,
          chatController: chatController,
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final InvoiceRecord invoice;
  final bool isBought;
  final ChatController chatController;

  const _OrderCard({
    required this.invoice,
    required this.isBought,
    required this.chatController,
  });

  Color _getStatusColor(String status) {
    if (status.contains('Pending Payment') ||
        status.contains('Awaiting Payment')) {
      return const Color(0xFFD4A017); // Golden/Mustard
    } else if (status.contains('Delivery Pending') ||
        status.contains('Waiting for Delivery')) {
      return const Color(0xFF008CC9); // Blue
    } else if (status.contains('Completed') ||
        status.contains('Payment Received')) {
      return const Color(0xFF1B834F); // Green
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(invoice.statusLabel);

    // Determine if we should show the package box icon (Sold tab specific)
    final bool showPackageIcon =
        !isBought &&
        (invoice.statusLabel.contains('Waiting for Delivery') ||
            invoice.statusLabel == 'Payment Received' ||
            invoice.statusLabel == 'Completed');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      // No card-level padding to keep image flush if needed, applying specifically below
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Status Overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      // bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Container(
                      width: 130, // Increased width
                      height:
                          180, // Increased height to match info height better
                      decoration: BoxDecoration(color: Colors.grey.shade100),
                      child: Image.asset(
                        invoice.productImagePath,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16), // Match card corner
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        invoice.statusLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11, // Slightly larger
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Order Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    right: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.productName,
                        style: const TextStyle(
                          fontSize: 18, // Reduced from 22
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${invoice.unitPrice} MRU / Kg',
                        style: const TextStyle(
                          fontSize: 14, // Reduced from 16
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B834F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isBought
                            ? '${invoice.quantity} Kg Bought'
                            : '${invoice.quantity} Kg Sold',
                        style: const TextStyle(
                          fontSize: 13, // Reduced from 15
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isBought
                            ? 'Seller: ${invoice.buyerName}'
                            : 'Buyer: ${invoice.buyerName}',
                        style: TextStyle(
                          fontSize: 13, // Reduced from 15
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Total Amount: ',
                              style: TextStyle(
                                fontSize: 13, // Reduced from 15
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '${invoice.totalAmount} MRU',
                              style: const TextStyle(
                                fontSize: 13, // Reduced from 15
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Invoice Generated: ${invoice.invoiceDate}',
                        style: TextStyle(
                          fontSize: 12, // Reduced from 13
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (invoice.paymentDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          isBought
                              ? 'Payment: ${invoice.paymentDate}'
                              : 'Payment from Buyer: ${invoice.paymentDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (invoice.paymentFromAdminDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Payment from Admin: ${invoice.paymentFromAdminDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (invoice.paymentReleaseDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Payment Release Date: ${invoice.paymentReleaseDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (invoice.dispatchedDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Dispatched: ${invoice.dispatchedDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (invoice.deliveredDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Delivered: ${invoice.deliveredDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (showPackageIcon)
                Container(
                  width: 75,
                  height: 75,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Image.asset(
                    'lib/assets/images/categories/Rounded rectangle.png',
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    List<Widget> buttons = [];

    // Always show View Invoice
    buttons.add(
      Expanded(
        child: OutlinedButton(
          onPressed: () {
            Get.snackbar(
              'Invoice',
              'Opening Invoice PDF...',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF1B834F),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            side: const BorderSide(color: Color(0xFF1B834F), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'View Invoice',
            style: TextStyle(
              color: Color(0xFF1B834F),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    // Determine secondary action
    String? actionLabel;
    VoidCallback? actionCallback;

    if (isBought) {
      if (invoice.statusLabel == 'Pending Payment') {
        actionLabel = 'Pay Now';
        actionCallback = () {
          chatController.updateInvoiceStatus(
            invoice.id,
            'Delivery Pending',
            const Color(0xFF008CC9),
            false,
            paymentDate: '10 Nov 2025',
          );
        };
      } else if (invoice.statusLabel == 'Delivery Pending') {
        actionLabel = 'Received';
        actionCallback =
            () => _showProofSheet(
              context,
              title: 'Upload Delivery Proof',
              successStatus: 'Completed',
              successColor: const Color(0xFF1B834F),
              isCompleted: true,
              deliveredDate: '12 Nov 2025',
              showDispute: true,
            );
      }
    } else {
      // Sold tab actions
      if (invoice.statusLabel == 'Delivery Pending') {
        actionLabel = 'Dispatch';
        actionCallback =
            () => _showProofSheet(
              context,
              title: 'Upload Delivery Proof',
              successStatus: 'Waiting for Delivery\ncomplete',
              successColor: const Color(0xFF008CC9),
              isCompleted: false,
              dispatchedDate: '12 Nov 2025',
            );
      }
    }

    if (actionLabel != null) {
      buttons.add(const SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: actionCallback,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B834F),
              minimumSize: const Size.fromHeight(44),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 16,
        left: 16,
        right: 16,
      ), // Increased horizontal padding for buttons
      child: Row(children: buttons),
    );
  }

  void _showProofSheet(
    BuildContext context, {
    required String title,
    required String successStatus,
    required Color successColor,
    required bool isCompleted,
    String? dispatchedDate,
    String? deliveredDate,
    bool showDispute = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.only(top: 40), // Space for title
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(thickness: 1, height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Color(0xFF1B834F),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Upload Images',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              side: const BorderSide(
                                color: Color(0xFF1B834F),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF1B834F),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              chatController.updateInvoiceStatus(
                                invoice.id,
                                successStatus,
                                successColor,
                                isCompleted,
                                dispatchedDate: dispatchedDate,
                                deliveredDate: deliveredDate,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B834F),
                              minimumSize: const Size.fromHeight(54),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showDispute) ...[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(() => DisputeScreen(orderId: invoice.id));
                      },
                      child: const Text(
                        'Raise Dispute',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            Positioned(
              top: -60,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
