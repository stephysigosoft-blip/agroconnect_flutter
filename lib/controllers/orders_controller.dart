import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../utils/invoice_pdf_helper.dart';

class OrdersController extends GetxController {
  final RxList<InvoiceRecord> boughtOrders = <InvoiceRecord>[].obs;
  final RxList<InvoiceRecord> soldOrders = <InvoiceRecord>[].obs;
  final RxBool isLoading = false.obs;

  // Pagination State
  final RxInt boughtPage = 1.obs;
  final RxBool hasMoreBought = true.obs;
  final RxBool isLoadingMoreBought = false.obs;

  final RxInt soldPage = 1.obs;
  final RxBool hasMoreSold = true.obs;
  final RxBool isLoadingMoreSold = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBoughtOrders();
  }

  Future<void> fetchBoughtOrders({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMoreBought.value || !hasMoreBought.value) return;
        isLoadingMoreBought.value = true;
      } else {
        isLoading.value = true;
        boughtPage.value = 1;
        hasMoreBought.value = true;
      }
      final apiService = Get.find<ApiService>();
      final response = await apiService.getBoughtOrders(page: boughtPage.value);

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        final newOrders = _mapOrders(data);

        if (loadMore) {
          boughtOrders.addAll(newOrders);
        } else {
          boughtOrders.assignAll(newOrders);
        }

        hasMoreBought.value = newOrders.length >= 10;
        if (newOrders.isNotEmpty) {
          boughtPage.value++;
        }
      }
    } finally {
      isLoading.value = false;
      isLoadingMoreBought.value = false;
    }
  }

  Future<void> fetchSellerOrders({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMoreSold.value || !hasMoreSold.value) return;
        isLoadingMoreSold.value = true;
      } else {
        // If initially loading and list is empty or force refresh
        if (soldOrders.isEmpty || !loadMore) {
          isLoading.value = true;
          soldPage.value = 1;
          hasMoreSold.value = true;
        }
      }

      final apiService = Get.find<ApiService>();
      final response = await apiService.getSellerOrders(page: soldPage.value);

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        final newOrders = _mapOrders(data);

        if (loadMore) {
          soldOrders.addAll(newOrders);
        } else {
          soldOrders.assignAll(newOrders);
        }

        hasMoreSold.value = newOrders.length >= 10;
        if (newOrders.isNotEmpty) {
          soldPage.value++;
        }
      }
    } finally {
      isLoading.value = false;
      isLoadingMoreSold.value = false;
    }
  }

  Future<void> fetchOrders() async {
    // This method can now be used for a full refresh if needed
    await Future.wait([fetchBoughtOrders(), fetchSellerOrders()]);
  }

  List _extractDataList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData;
    if (rawData is Map) {
      if (rawData.containsKey('data') && rawData['data'] is List) {
        return rawData['data'];
      }
      for (var value in rawData.values) {
        if (value is Map &&
            value.containsKey('data') &&
            value['data'] is List) {
          return value['data'];
        }
        if (value is List) return value;
      }
    }
    return [];
  }

  List<InvoiceRecord> _mapOrders(List data) {
    return data.map((json) {
      return InvoiceRecord(
        id: json['id'].toString(),
        productName: json['product']?['name_en'] ?? 'Product',
        productNameMap: {
          'en': (json['product']?['name_en'] ?? 'Product').toString(),
          'ar':
              (json['product']?['name_ar'] ??
                      json['product']?['name_en'] ??
                      'Product')
                  .toString(),
          'fr':
              (json['product']?['name_fr'] ??
                      json['product']?['name_en'] ??
                      'Product')
                  .toString(),
        },
        productImagePath:
            (json['product']?['images'] as List?)?.first?.toString() ??
            'lib/assets/images/categories/Rounded rectangle.png',
        unitPrice: (json['price'] ?? 0).toString(),
        quantity: (json['quantity'] ?? 0).toString(),
        totalAmount: (json['total'] ?? 0).toString(),
        buyerName: json['buyer']?['name'] ?? 'Buyer',
        invoiceDate: json['created_at'] ?? '',
        statusLabel: json['status'] ?? 'Pending',
        statusColor: _getStatusColor(json['status'] ?? ''),
        isCompleted: json['status'] == 'completed',
        pdfPath: '',
        isSold:
            false, // This flag might need adjustment based on which list it is
      );
    }).toList();
  }

  Color _getStatusColor(String status) {
    if (status.contains('Pending Payment') ||
        status.contains('Awaiting Payment')) {
      return const Color(0xFFD4A017);
    } else if (status.contains('Delivery Pending') ||
        status.contains('Waiting for Delivery')) {
      return const Color(0xFF008CC9);
    } else if (status.contains('Completed') ||
        status.contains('Payment Received')) {
      return const Color(0xFF1B834F);
    }
    return Colors.grey;
  }
}
