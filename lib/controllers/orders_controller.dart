import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../utils/invoice_pdf_helper.dart';
import 'chat_controller.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';

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
    fetchSellerOrders();
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
        final newOrders = _mapOrders(data, isSeller: false);

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
        final newOrders = _mapOrders(data, isSeller: true);

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

  List<InvoiceRecord> _mapOrders(List data, {required bool isSeller}) {
    return data.map((json) {
      final product = json['product'] ?? json['ad'] ?? {};

      // Image Search similar to ChatThread logic
      String avatar = '';
      final rawImg =
          (product['image_path'] ??
                  product['main_image'] ??
                  product['thumbnail'] ??
                  product['product_image'] ??
                  product['image'] ??
                  '')
              .toString();

      if (rawImg != 'null' && rawImg.isNotEmpty) {
        avatar = rawImg;
      } else {
        // ... (remaining image search logic)
        for (var key in [
          'image_path',
          'main_image',
          'thumbnail',
          'product_image',
          'image',
        ]) {
          if (product[key] != null) {
            avatar = product[key].toString();
            break;
          }
        }
        if (avatar.isEmpty) {
          final media = product['media'];
          if (media is List && media.isNotEmpty) {
            avatar =
                (media[0]['image_path'] ?? media[0]['path'] ?? '').toString();
          }
        }
      }

      String normalizedImage = ChatThread.normalizeAvatarPath(avatar);

      // Fallback to global product cache if image is still missing
      if (normalizedImage.isEmpty || normalizedImage == 'null') {
        final pId = (json['product_id'] ?? product['id'] ?? '').toString();
        if (pId.isNotEmpty && pId != 'null') {
          normalizedImage = ChatThread.productCache[pId]?.image ?? '';
        }
      }

      if (normalizedImage.isEmpty) {
        normalizedImage = 'lib/assets/images/categories/Rounded rectangle.png';
      }

      final qty = double.tryParse(json['quantity']?.toString() ?? '0') ?? 0;
      final finalPrice =
          double.tryParse(
            json['final_price']?.toString() ?? json['price']?.toString() ?? '0',
          ) ??
          0;
      final totalPrice =
          double.tryParse(
            json['total_price']?.toString() ?? json['total']?.toString() ?? '0',
          ) ??
          0;

      double calculatedUnitPrice = 0;
      if (qty > 0) {
        calculatedUnitPrice = finalPrice / qty;
      } else {
        calculatedUnitPrice = finalPrice;
      }

      // Map status Label based on requirements
      final int rawStatus =
          int.tryParse(json['status']?.toString() ?? '0') ?? 0;
      String statusLabel = (json['status_label'] ?? '').toString();

      if (statusLabel.isEmpty || statusLabel == 'null') {
        if (isSeller) {
          switch (rawStatus) {
            case 0:
              statusLabel = 'Awaiting Payment';
              break;
            case 1:
              statusLabel = 'Delivery Pending';
              break;
            case 2:
              statusLabel = 'Waiting for Delivery complete';
              break;
            case 3:
              statusLabel = 'Payment Received';
              break;
            default:
              statusLabel = 'Order Placed';
          }
        } else {
          switch (rawStatus) {
            case 0:
              statusLabel = 'Pending Payment';
              break;
            case 1:
              statusLabel = 'Delivery Pending';
              break;
            case 2:
              statusLabel = 'Delivery Pending';
              break;
            case 3:
              statusLabel = 'Completed';
              break;
            default:
              statusLabel = 'Order Placed';
          }
        }
      }

      return InvoiceRecord(
        id: json['id'].toString(),
        productName: product['name_en'] ?? 'Product',
        productNameMap: {
          'en': (product['name_en'] ?? 'Product').toString(),
          'ar':
              (product['name_ar'] ?? product['name_en'] ?? 'Product')
                  .toString(),
          'fr':
              (product['name_fr'] ?? product['name_en'] ?? 'Product')
                  .toString(),
        },
        productImagePath: normalizedImage,
        unitPrice: (calculatedUnitPrice > 0
                ? calculatedUnitPrice
                : (double.tryParse(json['original_price']?.toString() ?? '0') ??
                    0))
            .toStringAsFixed(2),
        quantity: qty.toStringAsFixed(0),
        totalAmount: totalPrice.toStringAsFixed(2),
        buyerName:
            (json['seller']?['name'] ?? json['buyer']?['name'] ?? 'Partner')
                .toString(),
        invoiceDate: json['created_at'] ?? '',
        statusLabel: statusLabel,
        statusColor: _getStatusColor(statusLabel),
        status: rawStatus,
        isCompleted: rawStatus == 3,
        pdfPath: '',
        isSold: isSeller,
      );
    }).toList();
  }

  Color _getStatusColor(String status) {
    if (status.contains('Pending Payment') ||
        status.contains('Awaiting Payment') ||
        status.contains('Waiting for Payment')) {
      return const Color(0xFFD4A017);
    } else if (status.contains('Delivery Pending') ||
        status.contains('Waiting for Delivery') ||
        status.contains('Dispatched') ||
        status.contains('Waiting for Delivery complete')) {
      return const Color(0xFF008CC9);
    } else if (status.contains('Completed') ||
        status.contains('Payment Received') ||
        status.contains('Payment Completed') ||
        status.contains('Success')) {
      return const Color(0xFF1B834F);
    }
    return Colors.grey;
  }

  Future<void> placeOrder(String orderId) async {
    try {
      isLoading.value = true;
      final l10n = AppLocalizations.of(Get.context!)!;
      debugPrint('Confirming order for ID: $orderId');

      final apiService = Get.find<ApiService>();
      final response = await apiService.completePayment(orderId);

      if (response != null && response['status'] == true) {
        Get.back(); // Close summary screen
        Get.snackbar(
          l10n.success,
          l10n.orderConfirmedSuccess,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );

        // Refresh orders list to reflect changes
        fetchBoughtOrders();
      } else {
        Get.snackbar(
          l10n.error,
          l10n.orderConfirmedFailed,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.error,
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDispute({
    required String orderId,
    required String reason,
    required String message,
    List<XFile>? images,
  }) async {
    try {
      isLoading.value = true;
      final l10n = AppLocalizations.of(Get.context!)!;
      final apiService = Get.find<ApiService>();
      final response = await apiService.disputeOrder(
        orderId: orderId,
        reason: reason,
        message: message,
        images: images,
      );

      if (response != null && response['status'] == true) {
        Get.back(); // Close DisputeScreen
        Get.snackbar(
          l10n.success,
          l10n.disputeSubmittedSuccess,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        Get.snackbar(
          l10n.error,
          l10n.disputeSubmittedFailed,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.error,
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markOrderAsReceived({
    required String orderId,
    List<XFile>? images,
  }) async {
    try {
      isLoading.value = true;
      final l10n = AppLocalizations.of(Get.context!)!;
      final apiService = Get.find<ApiService>();
      final response = await apiService.markAsReceived(
        orderId: orderId,
        images: images,
      );

      if (response != null && response['status'] == true) {
        Get.back(); // Close BottomSheet
        fetchBoughtOrders(); // Refresh list to update UI/remove button
        Get.snackbar(
          l10n.success,
          l10n.orderMarkedReceived,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        String errMsg = l10n.orderMarkedReceivedFailed;
        if (response != null && response['message'] != null) {
          errMsg = response['message'].toString();
        }
        Get.snackbar(
          l10n.error,
          errMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> dispatchOrder({
    required String orderId,
    List<XFile>? images,
  }) async {
    try {
      isLoading.value = true;
      final l10n = AppLocalizations.of(Get.context!)!;

      final apiService = Get.find<ApiService>();
      final response = await apiService.dispatchOrder(
        orderId: orderId,
        images: images,
      );

      if (response != null && response['status'] == true) {
        Get.back(); // Close BottomSheet
        fetchSellerOrders(); // Refresh list to update UI/remove button
        Get.snackbar(
          l10n.success,
          l10n.orderDispatchedSuccess,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        String errMsg = l10n.orderDispatchedFailed;
        if (response != null && response['message'] != null) {
          errMsg = response['message'].toString();
        }
        Get.snackbar(
          l10n.error,
          errMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> viewInvoice(
    InvoiceRecord? invoiceRecord, {
    String? orderId,
  }) async {
    final String actualId = orderId ?? invoiceRecord?.id ?? '';
    if (actualId.isEmpty) return;

    try {
      isLoading.value = true;
      final apiService = Get.find<ApiService>();

      await apiService.getViewInvoice(actualId);
      final l10n = AppLocalizations.of(Get.context!)!;

      // We use the invoiceRecord (passed from screen) OR find it in our lists
      InvoiceRecord? record = invoiceRecord;
      if (record == null) {
        record =
            boughtOrders.firstWhereOrNull((o) => o.id == actualId) ??
            soldOrders.firstWhereOrNull((o) => o.id == actualId);
      }

      // If still missing, try fetching once if lists are empty
      if (record == null && boughtOrders.isEmpty && soldOrders.isEmpty) {
        await fetchBoughtOrders();
        await fetchSellerOrders();
        record =
            boughtOrders.firstWhereOrNull((o) => o.id == actualId) ??
            soldOrders.firstWhereOrNull((o) => o.id == actualId);
      }

      if (record == null) {
        Get.snackbar(
          l10n.error,
          l10n.couldNotFindOrderDetails(actualId),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      final String productName = record.productName;
      final String totalAmount = record.totalAmount;
      final String quantity = record.quantity;
      final String imageUrl = record.productImagePath;

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.invoiceDetailsTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.orderDetailsTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(l10n.productName, productName),
                        _buildDetailRow(
                          l10n.quantity,
                          '$quantity ${l10n.unitKg}',
                        ),
                        _buildDetailRow(
                          l10n.price,
                          '$totalAmount ${l10n.currencyMru}',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.productImageTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child:
                                imageUrl.startsWith('http')
                                    ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                              ),
                                    )
                                    : Image.asset(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
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
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while fetching the invoice',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
