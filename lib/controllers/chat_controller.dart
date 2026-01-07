import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../utils/invoice_pdf_helper.dart';

class ChatThread {
  final String id;
  final String title;
  final String lastMessage;
  final String timeLabel;
  final String avatarPath;

  const ChatThread({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timeLabel,
    required this.avatarPath,
  });

  ChatThread copyWith({String? lastMessage, String? timeLabel}) {
    return ChatThread(
      id: id,
      title: title,
      lastMessage: lastMessage ?? this.lastMessage,
      timeLabel: timeLabel ?? this.timeLabel,
      avatarPath: avatarPath,
    );
  }
}

class ChatController extends GetxController {
  final RxList<ChatThread> threads =
      <ChatThread>[
        const ChatThread(
          id: '1',
          title: 'Millet',
          lastMessage: 'Etiam at vulputate dui. Ut venenatis nisi id...',
          timeLabel: '10:00 AM',
          avatarPath: 'lib/assets/images/categories/Rounded rectangle.png',
        ),
        const ChatThread(
          id: '2',
          title: 'Tomato',
          lastMessage: 'Etiam at vulputate dui. Ut venenatis nisi id...',
          timeLabel: '10:00 AM',
          avatarPath: 'lib/assets/images/categories/Rounded rectangle.png',
        ),
        const ChatThread(
          id: '3',
          title: 'Sorghum',
          lastMessage: 'Etiam at vulputate dui. Ut venenatis nisi id...',
          timeLabel: '10:00 AM',
          avatarPath: 'lib/assets/images/categories/Rounded rectangle.png',
        ),
      ].obs;

  final RxList<InvoiceRecord> invoices =
      <InvoiceRecord>[
        // Bought Tab
        InvoiceRecord(
          id: 'inv_001',
          productName: 'Millet',
          productImagePath: "lib/assets/images/product's/millet.png",
          unitPrice: '90',
          quantity: '800',
          totalAmount: '1000',
          buyerName: 'Salem',
          invoiceDate: '10 Nov 2025',
          statusLabel: 'Pending Payment',
          statusColor: const Color(0xFFD4A017),
          isCompleted: false,
          pdfPath: '',
          isSold: false,
        ),
        // Sold Tab Items matching Screenshot
        InvoiceRecord(
          id: 'inv_sold_1',
          productName: 'Millet',
          productImagePath: "lib/assets/images/product's/millet.png",
          unitPrice: '90',
          quantity: '800',
          totalAmount: '1000',
          buyerName: 'Salem',
          invoiceDate: '10 Nov 2025',
          statusLabel: 'Awaiting Payment',
          statusColor: const Color(0xFFD4A017),
          isCompleted: false,
          pdfPath: '',
          isSold: true,
        ),
        InvoiceRecord(
          id: 'inv_sold_2',
          productName: 'Tomato',
          productImagePath: "lib/assets/images/product's/tomato.png",
          unitPrice: '90',
          quantity: '800',
          totalAmount: '1000',
          buyerName: 'Salem',
          invoiceDate: '10 Nov 2025',
          statusLabel: 'Delivery Pending',
          statusColor: const Color(0xFF008CC9),
          isCompleted: false,
          pdfPath: '',
          isSold: true,
          paymentDate: '10 Nov 2025', // Payment from Buyer
        ),
        InvoiceRecord(
          id: 'inv_sold_3',
          productName: 'Sorghum',
          productImagePath: "lib/assets/images/product's/sorghum.png",
          unitPrice: '90',
          quantity: '800',
          totalAmount: '1000',
          buyerName: 'Salem',
          invoiceDate: '10 Nov 2025',
          statusLabel: 'Waiting for Delivery\ncomplete',
          statusColor: const Color(0xFF008CC9),
          isCompleted: false,
          pdfPath: '',
          isSold: true,
          paymentDate: '10 Nov 2025',
          dispatchedDate: '12 Nov 2025',
        ),
        InvoiceRecord(
          id: 'inv_sold_4',
          productName: 'Sorghum',
          productImagePath: "lib/assets/images/product's/sorghum.png",
          unitPrice: '90',
          quantity: '800',
          totalAmount: '1000',
          buyerName: 'Salem',
          invoiceDate: '10 Nov 2025',
          statusLabel: 'Payment Received',
          statusColor: const Color(0xFF1B834F),
          isCompleted: false,
          pdfPath: '',
          isSold: true,
          paymentDate: '10 Nov 2025',
          paymentFromAdminDate: '12 Nov 2025',
          dispatchedDate: '12 Nov 2025',
        ),
        InvoiceRecord(
          id: 'inv_sold_5',
          productName: 'Onion',
          productImagePath: "lib/assets/images/product's/tomato.png",
          unitPrice: '90',
          quantity: '800',
          totalAmount: '1000',
          buyerName: 'Salem',
          invoiceDate: '10 Nov 2025',
          statusLabel: 'Completed',
          statusColor: const Color(0xFF1B834F),
          isCompleted: true,
          pdfPath: '',
          isSold: true,
          paymentReleaseDate: '10 Nov 2025',
          deliveredDate: '13 Nov 2025',
        ),
      ].obs;

  void sendOffer({required Product product, required String quantityKg}) {
    final id = product.id;
    final timeLabel = _formatTime(DateTime.now());
    final message = 'Offer: $quantityKg Kg of ${product.name}';

    final existingIndex = threads.indexWhere((t) => t.id == id);
    if (existingIndex >= 0) {
      threads[existingIndex] = threads[existingIndex].copyWith(
        lastMessage: message,
        timeLabel: timeLabel,
      );
    } else {
      threads.insert(
        0,
        ChatThread(
          id: id,
          title: product.name,
          lastMessage: message,
          timeLabel: timeLabel,
          avatarPath: product.imagePath,
        ),
      );
    }
  }

  void deleteThread(String id) {
    threads.removeWhere((t) => t.id == id);
  }

  void addInvoiceRecord({
    required ChatThread thread,
    required InvoiceData data,
    required String pdfPath,
    bool isSold = false,
  }) {
    final quantity = double.tryParse(data.quantity) ?? 0;
    final price = double.tryParse(data.price) ?? 0;
    final total = quantity * price + (double.tryParse(data.transportCost) ?? 0);

    invoices.insert(
      0,
      InvoiceRecord(
        id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
        productName: thread.title,
        productImagePath: thread.avatarPath,
        unitPrice: price.toStringAsFixed(0),
        quantity: quantity.toStringAsFixed(0),
        totalAmount: total.toStringAsFixed(0),
        buyerName: 'Salem',
        invoiceDate:
            '${DateTime.now().day} ${DateTime.now().month} ${DateTime.now().year}',
        statusLabel: 'Pending Payment',
        statusColor: const Color(0xFFF9A825),
        isCompleted: false,
        pdfPath: pdfPath,
        isSold: isSold,
      ),
    );
  }

  void updateInvoiceStatus(
    String id,
    String statusLabel,
    Color statusColor,
    bool isCompleted, {
    String? paymentDate,
    String? dispatchedDate,
    String? deliveredDate,
    String? paymentFromAdminDate,
    String? paymentReleaseDate,
  }) {
    final index = invoices.indexWhere((inv) => inv.id == id);
    if (index >= 0) {
      final inv = invoices[index];
      invoices[index] = InvoiceRecord(
        id: inv.id,
        productName: inv.productName,
        productImagePath: inv.productImagePath,
        unitPrice: inv.unitPrice,
        quantity: inv.quantity,
        totalAmount: inv.totalAmount,
        buyerName: inv.buyerName,
        invoiceDate: inv.invoiceDate,
        statusLabel: statusLabel,
        statusColor: statusColor,
        isCompleted: isCompleted,
        pdfPath: inv.pdfPath,
        isSold: inv.isSold,
        paymentDate: paymentDate ?? inv.paymentDate,
        dispatchedDate: dispatchedDate ?? inv.dispatchedDate,
        deliveredDate: deliveredDate ?? inv.deliveredDate,
        paymentFromAdminDate: paymentFromAdminDate ?? inv.paymentFromAdminDate,
        paymentReleaseDate: paymentReleaseDate ?? inv.paymentReleaseDate,
      );
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
