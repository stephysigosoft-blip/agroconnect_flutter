import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/kyc_controller.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments (packageId, paymentMethod)
    final args = Get.arguments as Map<String, dynamic>;
    final KycController controller = Get.put(KycController());

    // Set package/product info in controller
    controller.setPackageInfo(
      args['packageId'],
      args['paymentMethod'],
      pId: args['productId'],
      oId: args['orderId'],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
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
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.kycVerification,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.completeKyc,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            _buildField(
              label: AppLocalizations.of(context)!.fullName,
              placeholder: AppLocalizations.of(context)!.enterFullName,
              controller: controller.nameController,
            ),
            const SizedBox(height: 16),

            _buildField(
              label: AppLocalizations.of(context)!.idProofNumber,
              placeholder: AppLocalizations.of(context)!.enterNationalId,
              controller: controller.idNumberController,
            ),
            const SizedBox(height: 16),

            _buildField(
              label: AppLocalizations.of(context)!.address,
              placeholder: AppLocalizations.of(context)!.enterAddress,
              controller: controller.addressController,
            ),
            const SizedBox(height: 16),

            _buildField(
              label: AppLocalizations.of(context)!.paymentIdRef,
              placeholder:
                  AppLocalizations.of(context)!.enterTransactionReceipt,
              controller: controller.paymentIdController,
            ),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : () => controller.submitKycAndBuy(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B834F),
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child:
                  controller.isLoading.value
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        AppLocalizations.of(context)!.submitBuyNow,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
