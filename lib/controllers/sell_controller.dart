import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../services/api_service.dart';

class SellController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final RxBool isPosting = false.obs;

  Future<Map<String, dynamic>?> postAd({
    required String title,
    required String pricePerKg,
    required String quantity,
    required String description,
    required String region,
    required List<String> images,
    required String latitude,
    required String longitude,
    required int categoryId,
  }) async {
    try {
      isPosting.value = true;

      // Construct FormData
      final Map<String, dynamic> data = {
        'title': title,
        'title_en':
            title, // Duplicating title just in case, though not explicitly asked
        'title_fr': title,
        'title_ar': title,
        'price_per_kg': pricePerKg,
        'quantity': quantity,
        'description': description,
        'description_en': description, // Duplicating description too
        'description_fr': description,
        'description_ar': description,
        'region': region,
        'latitude': latitude,
        'longitude': longitude,
        'category_id': categoryId,
        'category_id_en': categoryId,
        'category_id_fr': categoryId,
        'category_id_ar': categoryId,
      };

      final dio.FormData formData = dio.FormData.fromMap(data);

      // Add images for all languages
      for (int i = 0; i < images.length; i++) {
        // Create new MultipartFile instances for each field to ensure fresh streams
        formData.files.add(
          MapEntry('images[]', await dio.MultipartFile.fromFile(images[i])),
        );
        formData.files.add(
          MapEntry('images_en[]', await dio.MultipartFile.fromFile(images[i])),
        );
        formData.files.add(
          MapEntry('images_fr[]', await dio.MultipartFile.fromFile(images[i])),
        );
        formData.files.add(
          MapEntry('images_ar[]', await dio.MultipartFile.fromFile(images[i])),
        );
      }

      final response = await _apiService.createAds(formData);
      return response;
    } catch (e) {
      debugPrint('❌ [SellController] Error posting ad: $e');
      return {'status': false, 'message': e.toString()};
    } finally {
      isPosting.value = false;
    }
  }

  Future<Map<String, dynamic>?> updateAd({
    required dynamic adId,
    required String title,
    required String pricePerKg,
    required String quantity,
    required String description,
  }) async {
    try {
      isPosting.value = true;

      final Map<String, dynamic> data = {
        'title': title,
        'price_per_kg': pricePerKg,
        'quantity': quantity,
        'description': description,
      };

      final dio.FormData formData = dio.FormData.fromMap(data);

      final response = await _apiService.updateAd(adId, formData);
      return response;
    } catch (e) {
      debugPrint('❌ [SellController] Error updating ad: $e');
      return {'status': false, 'message': e.toString()};
    } finally {
      isPosting.value = false;
    }
  }
}
