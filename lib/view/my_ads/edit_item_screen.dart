import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../controllers/my_ads_controller.dart';
import '../../controllers/home_controller.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';

class EditItemScreen extends StatefulWidget {
  final Product product;
  const EditItemScreen({super.key, required this.product});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;
  final MyAdsController _myAdsController = Get.find<MyAdsController>();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.pricePerKg.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.availableQuantityKg.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _selectedCategoryId = widget.product.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        l10n.required,
        l10n.pleaseEnterProductName,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (_priceController.text.trim().isEmpty) {
      Get.snackbar(
        l10n.required,
        l10n.pleaseEnterPrice,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (double.tryParse(_priceController.text.trim()) == null ||
        double.parse(_priceController.text.trim()) <= 0) {
      Get.snackbar(
        l10n.invalidInput,
        l10n.validNumericPrice,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (_quantityController.text.trim().isEmpty) {
      Get.snackbar(
        l10n.required,
        l10n.pleaseEnterQuantity,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (double.tryParse(_quantityController.text.trim()) == null ||
        double.parse(_quantityController.text.trim()) <= 0) {
      Get.snackbar(
        l10n.invalidInput,
        l10n.validNumericQuantity,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        l10n.required,
        l10n.pleaseEnterDescription,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final success = await _myAdsController.updateAd(
      adId: widget.product.id,
      title: _nameController.text,
      description: _descriptionController.text,
      pricePerKg: _priceController.text,
      quantity: _quantityController.text,
      categoryId: _selectedCategoryId,
    );

    if (success) {
      Get.offNamed(
        '/adRepostedSuccess',
        arguments: {
          'onButtonPressed': () {
            // After edit, we can preview the updated product
            Get.offNamed(
              '/product',
              arguments: {'product': widget.product, 'showCancel': true},
            );
          },
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
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
        ),
        title: Text(
          AppLocalizations.of(context)!.editItem,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(AppLocalizations.of(context)!.productName),
                  const SizedBox(height: 8),
                  _buildTextField(_nameController, null),
                  const SizedBox(height: 20),
                  _buildLabel(AppLocalizations.of(context)!.price),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _priceController,
                    AppLocalizations.of(context)!.priceHint,
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryDropdown(AppLocalizations.of(context)!),
                  const SizedBox(height: 20),
                  _buildLabel(AppLocalizations.of(context)!.quantity),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _quantityController,
                    null,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(AppLocalizations.of(context)!.description),
                  const SizedBox(height: 8),
                  _buildTextField(_descriptionController, null, maxLines: 4),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _myAdsController.isLoading.value
                              ? null
                              : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B834F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child:
                          _myAdsController.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                AppLocalizations.of(context)!.update,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            if (_myAdsController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1B834F)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    // We use HomeController as it already has the categories list
    final homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(l10n.categories),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            final cats = homeController.categories;
            return DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              isExpanded: true,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF1B834F),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.categories,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B834F)),
                ),
              ),
              items:
                  cats.map((cat) {
                    final Map<String, dynamic> c = Map<String, dynamic>.from(
                      cat,
                    );
                    final id = int.tryParse(c['id'].toString()) ?? 0;
                    final langCode = Get.locale?.languageCode ?? 'en';
                    String label = '';
                    if (langCode == 'ar') {
                      label =
                          c['category_name_ar']?.toString() ??
                          c['name_ar']?.toString() ??
                          c['name']?.toString() ??
                          '';
                    } else if (langCode == 'fr') {
                      label =
                          c['category_name_fr']?.toString() ??
                          c['name_fr']?.toString() ??
                          c['name']?.toString() ??
                          '';
                    } else {
                      label =
                          c['category_name_en']?.toString() ??
                          c['name_en']?.toString() ??
                          c['name']?.toString() ??
                          '';
                    }
                    return DropdownMenuItem<int>(value: id, child: Text(label));
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategoryId = val;
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String? hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1B834F)),
          ),
        ),
      ),
    );
  }
}
