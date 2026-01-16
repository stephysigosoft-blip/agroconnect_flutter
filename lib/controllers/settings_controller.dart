import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/settings_model.dart';

class SettingsController extends GetxController {
  final Rx<SettingsModel?> settings = Rx<SettingsModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      final response = await apiService.fetchSettings();

      if (response != null && response['status'] == true) {
        final settingsData = _extractSettingsData(response['data']);
        if (settingsData != null) {
          settings.value = SettingsModel.fromJson(settingsData);
        }
      }
    } catch (e) {
      print('❌ [SettingsController] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? _extractSettingsData(dynamic rawData) {
    if (rawData == null) return null;
    if (rawData is Map<String, dynamic>) {
      // If rawData directly contains settings fields
      if (rawData.containsKey('notification_enabled') ||
          rawData.containsKey('notifications')) {
        return rawData;
      }
      // If settings are nested under a 'settings' key
      if (rawData.containsKey('settings') && rawData['settings'] is Map) {
        return rawData['settings'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  void toggleNotifications(bool value) {
    if (settings.value != null) {
      settings.value = SettingsModel(notificationEnabled: value);
      // TODO: Call API to update settings on backend if needed
    }
  }

  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      final response = await apiService.deleteAccount();

      return response != null && response['status'] == true;
    } catch (e) {
      print('❌ [SettingsController] Error deleting account: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
