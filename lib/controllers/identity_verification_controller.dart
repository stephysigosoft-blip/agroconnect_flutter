import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../services/api_service.dart';

class IdentityVerificationController extends GetxController {
  final RxList<XFile> nationalIDProofs = <XFile>[].obs;
  final RxList<XFile> businessCertificates = <XFile>[].obs;
  final RxList<XFile> farmCertificates = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(String type) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40, // Increased compression
      maxWidth: 800, // Reduced dimensions
      maxHeight: 800,
    );
    if (image != null) {
      final bytes = await File(image.path).length();
      print('📸 Picked $type image: ${bytes / 1024} KB');
      if (type == 'national') {
        nationalIDProofs.add(image);
      } else if (type == 'business') {
        businessCertificates.add(image);
      } else if (type == 'farm') {
        farmCertificates.add(image);
      }
    }
  }

  void removeImage(String type, int index) {
    if (type == 'national') {
      nationalIDProofs.removeAt(index);
    } else if (type == 'business') {
      businessCertificates.removeAt(index);
    } else if (type == 'farm') {
      farmCertificates.removeAt(index);
    }
  }

  // No longer blocking the button via disabled state,
  // we use explicit validation to "identify" needed fields.
  bool get isSubmitEnabled => true;

  final RxBool isLoading = false.obs;

  Future<bool> submitDocuments() async {
    try {
      isLoading.value = true;
      final apiService = Get.find<ApiService>();

      final formData = dio.FormData();

      // Add National ID proofs
      for (var file in nationalIDProofs) {
        final bytes = await File(file.path).length();
        print('📤 Uploading national_id: ${bytes / 1024} KB');
        formData.files.add(
          MapEntry(
            'national_id[]',
            await dio.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      // Add Business certificates
      for (var file in businessCertificates) {
        final bytes = await File(file.path).length();
        print('📤 Uploading business_certificate: ${bytes / 1024} KB');
        formData.files.add(
          MapEntry(
            'business_certificate[]',
            await dio.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      // Add Farm certificates (Optional)
      for (var file in farmCertificates) {
        final bytes = await File(file.path).length();
        print('📤 Uploading farm_certificate: ${bytes / 1024} KB');
        formData.files.add(
          MapEntry(
            'farm_certificate[]',
            await dio.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      final response = await apiService.uploadDocuments(formData);

      isLoading.value = false;
      return response != null && response['status'] == true;
    } catch (e) {
      isLoading.value = false;
      print('❌ Error submitting documents: $e');
      return false;
    }
  }
}
