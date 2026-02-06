import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/identity_verification_controller.dart';
import '../../l10n/app_localizations.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IdentityVerificationController());

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
          AppLocalizations.of(context)!.identityVerificationKyc,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUploadSection(
              title: AppLocalizations.of(context)!.uploadNationalIdProof,
              type: 'national',
              controller: controller,
            ),
            const SizedBox(height: 16),
            _buildUploadSection(
              title: AppLocalizations.of(context)!.uploadBusinessCertificate,
              type: 'business',
              controller: controller,
            ),
            const SizedBox(height: 16),
            _buildUploadSection(
              title: AppLocalizations.of(context)!.uploadFarmCertificate,
              type: 'farm',
              controller: controller,
            ),
            const SizedBox(height: 100), // Spacer for button
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => ElevatedButton(
              onPressed:
                  !controller.isLoading.value
                      ? () async {
                        if (controller.nationalIDProofs.isEmpty) {
                          Get.snackbar(
                            AppLocalizations.of(context)!.required,
                            AppLocalizations.of(
                              context,
                            )!.pleaseUploadNationalId,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                          return;
                        }
                        if (controller.businessCertificates.isEmpty) {
                          Get.snackbar(
                            AppLocalizations.of(context)!.required,
                            AppLocalizations.of(
                              context,
                            )!.pleaseUploadBusinessCertificate,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                          return;
                        }

                        final success = await controller.submitDocuments();
                        if (success) {
                          _showSubmissionPopup(context);
                        } else {
                          Get.snackbar(
                            AppLocalizations.of(context)!.error,
                            AppLocalizations.of(
                              context,
                            )!.failedToUploadDocuments,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B834F),
                disabledBackgroundColor: Colors.grey.shade300,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child:
                  controller.isLoading.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        AppLocalizations.of(context)!.verify,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required String type,
    required IdentityVerificationController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.pickImage(type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.file_upload_outlined,
                  color: Color(0xFF1B834F),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final list =
              type == 'national'
                  ? controller.nationalIDProofs
                  : type == 'business'
                  ? controller.businessCertificates
                  : controller.farmCertificates;

          if (list.isEmpty) return const SizedBox.shrink();

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                list.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(entry.value.path),
                          width: 150,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(type, entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          );
        }),
      ],
    );
  }

  void _showSubmissionPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.documentsSubmitted,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.documentsSubmittedDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Back to profile/previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B834F),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.done,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
