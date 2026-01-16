import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wallet_controller.dart';
import '../../utils/snackbar_helper.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: Center(
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
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildBalanceCard(context, controller),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.transactions.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.transactions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No transactions found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: controller.transactions.length,
                        separatorBuilder:
                            (context, index) => const Divider(height: 32),
                        itemBuilder: (context, index) {
                          final tx = controller.transactions[index];
                          return _buildTransactionItem(tx);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, WalletController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B834F), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B834F).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              '${controller.balance.value.toStringAsFixed(2)} MRU',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _showWithdrawDialog(context, controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Withdraw Money',
              style: TextStyle(
                color: Color(0xFF1B834F),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic tx) {
    final bool isCredit = tx['type'] == 'credit' || tx['type'] == 'received';
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? const Color(0xFF1B834F) : Colors.red,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx['title'] ?? 'Transaction',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tx['date'] ?? 'N/A',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          '${isCredit ? '+' : '-'}${tx['amount']} MRU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isCredit ? const Color(0xFF1B834F) : Colors.red,
          ),
        ),
      ],
    );
  }

  void _showWithdrawDialog(BuildContext context, WalletController controller) {
    final TextEditingController amountController = TextEditingController();
    Get.defaultDialog(
      title: 'Withdraw Money',
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter amount',
          prefixText: 'MRU ',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textConfirm: 'Withdraw',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF1B834F),
      onConfirm: () async {
        final double? amount = double.tryParse(amountController.text);
        if (amount == null || amount <= 0) {
          SnackBarHelper.showError(
            'Invalid Amount',
            'Please enter a valid amount',
          );
          return;
        }
        if (amount > controller.balance.value) {
          SnackBarHelper.showError(
            'Insufficient Balance',
            'You do not have enough balance to withdraw this amount',
          );
          return;
        }
        Get.back();
        await controller.withdraw(amount);
        SnackBarHelper.showSuccess(
          'Success',
          'Withdrawal request processed successfully!',
        );
      },
    );
  }
}
