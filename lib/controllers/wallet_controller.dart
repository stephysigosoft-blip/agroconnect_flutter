import 'package:get/get.dart';
// import 'package:dio/dio.dart' as dio;
// import '../services/api_service.dart';

class WalletController extends GetxController {
  final RxList<dynamic> transactions = <dynamic>[].obs;
  final RxDouble balance = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    // try {
    //   isLoading.value = true;
    //   final apiService = Get.find<ApiService>();
    //   final response = await apiService.getTransactions();
    //   if (response != null && response['status'] == true) {
    //     transactions.assignAll(response['data'] ?? []);
    //     // Assuming balance is part of the response or we calculate it
    //     balance.value =
    //         double.tryParse((response['balance'] ?? 0).toString()) ?? 0.0;
    //   }
    // } finally {
    //   isLoading.value = false;
    // }
  }

  Future<void> withdraw(double amount) async {
    // try {
    //   isLoading.value = true;
    //   final apiService = Get.find<ApiService>();
    //   final formData = dio.FormData.fromMap({'amount': amount});
    //   final response = await apiService.withdrawMoney(formData);
    //   if (response != null && response['status'] == true) {
    //     fetchTransactions(); // Refresh
    //   }
    // } finally {
    //   isLoading.value = false;
    // }
  }
}
