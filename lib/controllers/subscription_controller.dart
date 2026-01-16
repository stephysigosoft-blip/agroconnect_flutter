import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class SubscriptionController extends GetxController {
  final RxList<dynamic> myPackages = <dynamic>[].obs;
  final RxList<dynamic> allPackages = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  // Pagination State for Buy Packages
  final RxInt allPackagesPage = 1.obs;
  final RxBool hasMoreAllPackages = true.obs;
  final RxBool isLoadingMoreAllPackages = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchMyPackages() async {
    try {
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      print('🔄 Fetching MY packages (bought) from API (fetch-packages)...');
      final response =
          await apiService
              .fetchPackages(); // User: fetch-packages screen shows bought packages
      print('📦 MY Packages API Response: $response');

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        print('✅ MY Packages received: ${data.length} packages');
        myPackages.assignAll(data);
      } else {
        print('❌ MY Packages API returned null or status false');
      }
    } catch (e) {
      print('❌ Error fetching MY packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllPackages({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMoreAllPackages.value || !hasMoreAllPackages.value) return;
        isLoadingMoreAllPackages.value = true;
      } else {
        isLoading.value = true;
        allPackagesPage.value = 1;
        hasMoreAllPackages.value = true;
      }

      final apiService = Get.find<ApiService>();
      print(
        '🔄 Fetching BUY packages (available) from API (get-packages) Page: ${allPackagesPage.value}...',
      );
      final response = await apiService.getPackages(
        page: allPackagesPage.value,
        limit: 10,
      );
      print('📦 BUY Packages API Response: $response');

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        if (data.isEmpty) {
          if (!loadMore) {
            print('ℹ️ [SubscriptionController] backend returned 0 packages.');
            allPackages.clear();
          }
          hasMoreAllPackages.value = false;
        } else {
          print(
            '✅ [SubscriptionController] BUY Packages received: ${data.length} packages',
          );
          if (loadMore) {
            allPackages.addAll(data);
          } else {
            allPackages.assignAll(data);
          }

          if (data.length < 10) {
            hasMoreAllPackages.value = false;
          } else {
            allPackagesPage.value++;
          }
        }
      } else {
        print(
          '❌ [SubscriptionController] BUY Packages API returned null or status false',
        );
        if (!loadMore) allPackages.clear();
      }
    } catch (e, stackTrace) {
      print('❌ [SubscriptionController] Error fetching BUY packages: $e');
      print('Stack trace: $stackTrace');

      String errorMsg =
          'Failed to load packages. Please check your connection.';
      if (e is dio.DioException &&
          e.type == dio.DioExceptionType.receiveTimeout) {
        errorMsg =
            'Server is taking too long to respond. Please try again later.';
      }

      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List _extractDataList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData;
    if (rawData is Map) {
      if (rawData.containsKey('data') && rawData['data'] is List) {
        return rawData['data'];
      }
      if (rawData.containsKey('packages') && rawData['packages'] is List) {
        return rawData['packages'];
      }
      if (rawData.containsKey('wishlist') && rawData['wishlist'] is List) {
        return rawData['wishlist'];
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

  Future<bool> buyPackage({
    required dynamic packageId,
    required dynamic paymentMethod,
    required String paymentId,
    String? name,
    String? idNumber,
    String? address,
  }) async {
    try {
      print(
        '🚀 [SubscriptionController] buyPackage called for packageId: $packageId',
      );
      isLoading.value = true;
      final apiService = Get.find<ApiService>();

      // Ensure packageId and paymentMethod are passed in the format expected by the API
      final data = {
        'package_id': packageId.toString(),
        'payment_method': paymentMethod.toString(),
        'payment_id': paymentId,
        'payment_url': '',
        'payment_response': '',
        if (name != null) 'name': name,
        if (idNumber != null) 'id_number': idNumber,
        if (address != null) 'address': address,
      };

      final dio.FormData formData = dio.FormData.fromMap(data);

      print(
        '📤 [SubscriptionController] Sending buyPackage request with fields: $data',
      );
      final response = await apiService.buyPackage(formData);
      print('📥 [SubscriptionController] buyPackage response: $response');

      if (response != null) {
        final bool status = response['status'] == true;
        String message =
            status ? 'Package bought successfully' : 'Operation failed';

        if (response['message'] != null) {
          final msgData = response['message'];
          if (msgData is Map) {
            if (msgData.containsKey('message_en')) {
              final enMsg = msgData['message_en'];
              message = enMsg is List ? enMsg.join('\n') : enMsg.toString();
            } else if (msgData.containsKey('package_id')) {
              // Specifically handle the validation error shown in logs
              final pkgMsg = msgData['package_id'];
              message = pkgMsg is List ? pkgMsg.join('\n') : pkgMsg.toString();
            } else {
              final List errors = [];
              msgData.forEach((key, value) {
                if (value is List) {
                  errors.add(value.join('\n'));
                } else {
                  errors.add(value.toString());
                }
              });
              message = errors.isEmpty ? 'Validation error' : errors.join('\n');
            }
          } else {
            message = msgData.toString();
          }
        }

        Get.snackbar(
          status ? 'Success' : 'Notice',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: status ? const Color(0xFF1B834F) : Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );

        if (status) {
          await fetchMyPackages();
          return true;
        }
      }

      return false;
    } catch (e) {
      print('❌ [SubscriptionController] Error in buyPackage: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
