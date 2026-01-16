import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt page = 1.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoading.value || !hasMore.value) return;
        isLoading.value = true;
      } else {
        if (isLoading.value) return;
        isLoading.value = true;
        page.value = 1;
        notifications.clear();
      }

      final apiService = Get.find<ApiService>();
      final response = await apiService.getNotifications(page: page.value);

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        final List<NotificationModel> newNotifications =
            data.map((json) => NotificationModel.fromJson(json)).toList();

        if (loadMore) {
          notifications.addAll(newNotifications);
        } else {
          notifications.assignAll(newNotifications);
        }

        // Update pagination based on API metadata
        final paginationData = _extractPaginationData(response['data']);
        final currentPage = paginationData['current_page'] ?? page.value;
        final lastPage = paginationData['last_page'] ?? 1;
        final nextPageUrl = paginationData['next_page_url'];

        hasMore.value = nextPageUrl != null && currentPage < lastPage;
        if (newNotifications.isNotEmpty) {
          page.value++;
        }
      }
    } catch (e) {
      print('❌ [NotificationController] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _extractPaginationData(dynamic rawData) {
    if (rawData is Map && rawData.containsKey('notifications')) {
      final notifications = rawData['notifications'];
      if (notifications is Map) {
        return {
          'current_page': notifications['current_page'],
          'last_page': notifications['last_page'],
          'next_page_url': notifications['next_page_url'],
        };
      }
    }
    return {};
  }

  List _extractDataList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData;
    if (rawData is Map) {
      // Handle the specific structure: data.notifications.data
      if (rawData.containsKey('notifications') &&
          rawData['notifications'] is Map &&
          rawData['notifications']['data'] is List) {
        return rawData['notifications']['data'];
      }
      // Fallback: check for direct 'data' key
      if (rawData.containsKey('data') && rawData['data'] is List) {
        return rawData['data'];
      }
      // Fallback: search through all values
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
}
