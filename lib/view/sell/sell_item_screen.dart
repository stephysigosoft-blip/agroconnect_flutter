import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/subscription_controller.dart';
import '../../controllers/sell_controller.dart';
import '../../controllers/home_controller.dart';
import '../../utils/snackbar_helper.dart';
import '../../models/product.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'location_selection_screen.dart';
import '../../services/api_service.dart';

class SellItemScreen extends StatefulWidget {
  const SellItemScreen({super.key});

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final SellController _sellController = Get.put(SellController());
  late SubscriptionController _subscriptionController;
  bool _isGuest = false;
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void initState() {
    super.initState();
    _subscriptionController = Get.put(SubscriptionController());
    _checkGuestStatus();
    // Immediate check
    if (_subscriptionController.myPackages.isEmpty) {
      _subscriptionController.fetchMyPackages();
    }

    // Trigger pop-up check when entering this screen as well
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_subscriptionController.myPackages.isEmpty &&
          !_subscriptionController.isLoading.value) {
        _checkAndShowPopup();
      }
    });
  }

  Future<void> _checkGuestStatus() async {
    final isGuest = await _apiService.isGuest();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
      });
    }
  }

  void _checkAndShowPopup() async {
    // Re-fetch to be sure, unless already loaded
    if (_subscriptionController.myPackages.isEmpty) {
      await _subscriptionController.fetchMyPackages();
    }
    if (mounted && _subscriptionController.myPackages.isEmpty) {
      _showPackageErrorPopup(context);
    }
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  XFile? _selectedVideo;
  // ignore: unused_field
  String? _selectedLocation;
  String? _latitude;
  String? _longitude;
  int? _selectedCategoryId;

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({ImageSource? source}) async {
    if (_selectedImages.length >= 4) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showError(l10n.limitReached, l10n.max4Images);
      return;
    }

    try {
      // If source is not provided, show selection dialog
      ImageSource? imageSource = source;
      if (imageSource == null) {
        imageSource = await showModalBottomSheet<ImageSource>(
          context: context,
          builder:
              (context) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.photo_library,
                        color: const Color(0xFF1B834F),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.chooseFromGallery,
                      ),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.camera_alt,
                        color: const Color(0xFF1B834F),
                      ),
                      title: Text(AppLocalizations.of(context)!.takePhoto),
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                  ],
                ),
              ),
        );
      }

      if (imageSource != null) {
        final XFile? image = await _picker.pickImage(
          source: imageSource,
          imageQuality: 50, // Reduced quality to avoid 4MB limit
          maxWidth: 1024, // Limit dimensions
          maxHeight: 1024,
        );
        if (image != null) {
          setState(() {
            _selectedImages.add(image);
          });
        }
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showError(
        l10n.error,
        '${l10n.failedToPickImage}: ${e.toString()}',
      );
    }
  }

  Future<void> _pickVideo({ImageSource? source}) async {
    if (_selectedVideo != null) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showError(l10n.limitReached, l10n.max1Video);
      return;
    }

    try {
      // If source is not provided, show selection dialog
      ImageSource? videoSource = source;
      if (videoSource == null) {
        videoSource = await showModalBottomSheet<ImageSource>(
          context: context,
          builder:
              (context) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.video_library,
                        color: const Color(0xFF1B834F),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.chooseFromGallery,
                      ),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.videocam,
                        color: Color(0xFF1B834F),
                      ),
                      title: Text(AppLocalizations.of(context)!.recordVideo),
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                  ],
                ),
              ),
        );
      }

      if (videoSource != null) {
        final XFile? video = await _picker.pickVideo(source: videoSource);
        if (video != null) {
          setState(() {
            _selectedVideo = video;
          });
        }
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showError(
        l10n.error,
        '${l10n.failedToPickVideo}: ${e.toString()}',
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeVideo() {
    setState(() {
      _selectedVideo = null;
    });
  }

  Future<void> _selectLocation() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.selectRegion),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: const Text('Use Current Location'),
                  onTap: () async {
                    Get.back();
                    await _getCurrentLocation();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map, color: Color(0xFF1B834F)),
                  title: const Text('Select Location'),
                  onTap: () async {
                    Get.back(); // Close dialog
                    final result = await Get.to(
                      () => LocationSelectionScreen(
                        initialLatitude:
                            _latitude != null
                                ? double.tryParse(_latitude!) ?? 18.0735
                                : 18.0735,
                        initialLongitude:
                            _longitude != null
                                ? double.tryParse(_longitude!) ?? -15.9582
                                : -15.9582,
                      ),
                    );

                    if (result != null && result is Map) {
                      setState(() {
                        _latitude = result['latitude'];
                        _longitude = result['longitude'];
                        _selectedLocation = 'Custom Location';
                      });
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog with option to enable location
      final shouldOpenSettings = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Location Services Disabled'),
              content: const Text(
                'Location services are currently disabled. Would you like to enable them in settings?',
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          side: const BorderSide(color: Color(0xFF1B834F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF1B834F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Open Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      );

      if (shouldOpenSettings == true) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are denied.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permissions are permanently denied.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
        _selectedLocation = 'Current Location';
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      Get.snackbar(
        'Error',
        'Failed to get location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void _handlePost() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedCategoryId == null) {
      SnackBarHelper.showError(
        l10n.required,
        '${l10n.categories} ${l10n.required}',
      );
      return;
    }
    if (_productNameController.text.trim().isEmpty) {
      SnackBarHelper.showError(l10n.required, l10n.pleaseEnterProductName);
      return;
    }
    if (_priceController.text.trim().isEmpty) {
      SnackBarHelper.showError(l10n.required, l10n.pleaseEnterPrice);
      return;
    }
    if (double.tryParse(_priceController.text.trim()) == null ||
        double.parse(_priceController.text.trim()) <= 0) {
      SnackBarHelper.showError(l10n.invalidInput, l10n.validNumericPrice);
      return;
    }
    if (_quantityController.text.trim().isEmpty) {
      SnackBarHelper.showError(l10n.required, l10n.pleaseEnterQuantity);
      return;
    }
    if (double.tryParse(_quantityController.text.trim()) == null ||
        double.parse(_quantityController.text.trim()) <= 0) {
      SnackBarHelper.showError(l10n.invalidInput, l10n.validNumericQuantity);
      return;
    }
    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      SnackBarHelper.showError(l10n.required, l10n.pleaseSelectRegion);
      return;
    }
    if (_selectedImages.isEmpty) {
      SnackBarHelper.showError(l10n.required, l10n.pleaseAddOneImage);
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      SnackBarHelper.showError(l10n.required, l10n.pleaseEnterDescription);
      return;
    }

    _performPost();
  }

  Future<void> _performPost() async {
    final l10n = AppLocalizations.of(context)!;
    final response = await _sellController.postAd(
      title: _productNameController.text,
      pricePerKg: _priceController.text,
      quantity: _quantityController.text,
      description: _descriptionController.text,
      region: _selectedLocation ?? '',
      images: _selectedImages.map((e) => e.path).toList(),
      latitude: _latitude ?? '20.5184328',
      longitude: _longitude ?? '-13.1491552',
      categoryId: _selectedCategoryId!,
    );

    if (response != null && response['status'] == true) {
      final dynamic rawData = response['data'];
      dynamic productData;

      if (rawData is Map) {
        productData = rawData['product'] ?? rawData;
      } else if (rawData is List && rawData.isNotEmpty) {
        productData = rawData.first;
      } else {
        productData = rawData;
      }

      Product? product;
      if (productData != null && productData is Map) {
        try {
          product = Product.fromJson(Map<String, dynamic>.from(productData));
        } catch (e) {
          debugPrint('❌ Error parsing product from response: $e');
        }
      }

      Get.toNamed(
        '/adPostedSuccess',
        arguments: {
          'onButtonPressed': () {
            if (product != null) {
              Get.offNamed(
                '/product',
                arguments: {'product': product, 'showCancel': true},
              );
            } else {
              Get.until(
                (route) => Get.currentRoute == '/home' || route.isFirst,
              );
            }
          },
        },
      );
    } else {
      // Check if user already has packages
      final subController = Get.put(SubscriptionController());

      // Ensure we have the latest package info before deciding
      if (subController.myPackages.isEmpty) {
        await subController.fetchMyPackages();
      }

      if (subController.myPackages.isNotEmpty) {
        String errorMsg = l10n.failedToCreateAd;
        if (response != null && response['message'] != null) {
          final msg = response['message'];
          // Handle if message is a map (validation errors) or string
          if (msg is Map) {
            errorMsg = msg.values.join('\n');
          } else {
            errorMsg = msg.toString();
          }

          // Sanitize technical backend errors
          if (errorMsg.toLowerCase().contains('undefined variable') ||
              errorMsg.toLowerCase().contains('exception') ||
              errorMsg.toLowerCase().contains('sqlstate')) {
            errorMsg = l10n.serverErrorPostAd;
          }
        }
        SnackBarHelper.showError(l10n.error, errorMsg);
      } else {
        // If balance is insufficient or no package, show the popup
        _showPackageErrorPopup(context);
      }
    }
  }

  void _showPackageErrorPopup(BuildContext context) {
    showDialog(
      context: context,
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
                  AppLocalizations.of(context)!.sorry,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noActivePackageDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          side: const BorderSide(color: Color(0xFF1B834F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: const TextStyle(
                              color: Color(0xFF1B834F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final controller = Get.put(SubscriptionController());
                          await controller.fetchAllPackages();
                          Get.toNamed('/buyPackages');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: FittedBox(
                          child: Text(
                            AppLocalizations.of(context)!.buyPackage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Center(
          child: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Get.back();
              } else {
                Get.find<HomeController>().jumpToTab(0);
              }
            },
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
        title: Text(
          AppLocalizations.of(context)!.sellItem,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _isGuest ? () => _showLoginRequiredDialog(context) : null,
        behavior: HitTestBehavior.opaque,
        child: IgnorePointer(
          ignoring: _isGuest,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMPORTANT MESSAGE - NO ACTIVE PLAN
                Obx(() {
                  final subController = Get.find<SubscriptionController>();
                  // Only show if user has NO packages
                  if (subController.myPackages.isEmpty) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'No Active Plan. Please purchase a package.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/buyPackages'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                _buildImageUploadSection(),
                const SizedBox(height: 24),
                _buildFormFields(l10n),
                const SizedBox(height: 24),
                _buildLocationSection(),
                const SizedBox(height: 24),
                _buildTextField(
                  label: l10n.description,
                  controller: _descriptionController,
                  hintText: '',
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                _buildPostButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    final totalItems =
        _selectedImages.length + (_selectedVideo != null ? 1 : 0);
    final canAddMore =
        totalItems < 5 &&
        (_selectedVideo == null || _selectedImages.length < 4);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (totalItems == 0)
            GestureDetector(
              onTap: () async {
                final choice = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  builder:
                      (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                AppLocalizations.of(context)!.selectMediaType,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.photo_library,
                                color: const Color(0xFF1B834F),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.imageFromGallery,
                              ),
                              onTap:
                                  () => Navigator.pop(context, {
                                    'type': 'image',
                                    'source': ImageSource.gallery,
                                  }),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.camera_alt,
                                color: const Color(0xFF1B834F),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.takePhoto,
                              ),
                              onTap:
                                  () => Navigator.pop(context, {
                                    'type': 'image',
                                    'source': ImageSource.camera,
                                  }),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.video_library,
                                color: const Color(0xFF1B834F),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.videoFromGallery,
                              ),
                              onTap:
                                  () => Navigator.pop(context, {
                                    'type': 'video',
                                    'source': ImageSource.gallery,
                                  }),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.videocam,
                                color: const Color(0xFF1B834F),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.recordVideo,
                              ),
                              onTap:
                                  () => Navigator.pop(context, {
                                    'type': 'video',
                                    'source': ImageSource.camera,
                                  }),
                            ),
                          ],
                        ),
                      ),
                );

                if (choice != null) {
                  if (choice['type'] == 'image') {
                    await _pickImage(source: choice['source'] as ImageSource);
                  } else if (choice['type'] == 'video') {
                    await _pickVideo(source: choice['source'] as ImageSource);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF1B834F),
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.uploadImagesVideos,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.maxImagesVideoDesc,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (totalItems > 0) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.uploadImagesVideos,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (canAddMore)
                    GestureDetector(
                      onTap: () async {
                        final choice =
                            await showModalBottomSheet<Map<String, dynamic>>(
                              context: context,
                              builder:
                                  (context) => SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.addMedia,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (_selectedImages.length < 4) ...[
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_library,
                                              color: const Color(0xFF1B834F),
                                            ),
                                            title: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.imageFromGallery,
                                            ),
                                            onTap:
                                                () => Navigator.pop(context, {
                                                  'type': 'image',
                                                  'source': ImageSource.gallery,
                                                }),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              color: const Color(0xFF1B834F),
                                            ),
                                            title: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.takePhoto,
                                            ),
                                            onTap:
                                                () => Navigator.pop(context, {
                                                  'type': 'image',
                                                  'source': ImageSource.camera,
                                                }),
                                          ),
                                        ],
                                        if (_selectedVideo == null) ...[
                                          ListTile(
                                            leading: const Icon(
                                              Icons.video_library,
                                              color: const Color(0xFF1B834F),
                                            ),
                                            title: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.videoFromGallery,
                                            ),
                                            onTap:
                                                () => Navigator.pop(context, {
                                                  'type': 'video',
                                                  'source': ImageSource.gallery,
                                                }),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.videocam,
                                              color: const Color(0xFF1B834F),
                                            ),
                                            title: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.recordVideo,
                                            ),
                                            onTap:
                                                () => Navigator.pop(context, {
                                                  'type': 'video',
                                                  'source': ImageSource.camera,
                                                }),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                            );

                        if (choice != null) {
                          if (choice['type'] == 'image') {
                            await _pickImage(
                              source: choice['source'] as ImageSource,
                            );
                          } else if (choice['type'] == 'video') {
                            await _pickVideo(
                              source: choice['source'] as ImageSource,
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B834F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  ...List.generate(
                    _selectedImages.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImages[index].path),
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_selectedVideo != null)
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 75,
                              width: 75,
                              color: Colors.black,
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _removeVideo,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    final HomeController homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categories,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
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
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1B834F),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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

  Widget _buildFormFields(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: l10n.productName,
          controller: _productNameController,
          hintText: '',
        ),
        const SizedBox(height: 16),
        _buildCategoryDropdown(l10n),
        const SizedBox(height: 16),
        _buildTextField(
          label: l10n.price,
          controller: _priceController,
          hintText: l10n.priceHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: l10n.quantity,
          controller: _quantityController,
          hintText: '',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
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
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
              filled: false, // Removed as container provides fill
              // fillColor: Colors.white, // Removed as container provides fill
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF1B834F),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectRegion,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectLocation,
          child: Container(
            height: 71,
            width: 146,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                  "https://static-maps.yandex.ru/1.x/?ll=${_longitude ?? '-15.9582'},${_latitude ?? '18.0735'}&z=13&l=map&size=600,350",
                ),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.location_on, color: Colors.red, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: _sellController.isPosting.value ? null : _handlePost,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B834F),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              _sellController.isPosting.value
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    AppLocalizations.of(context)!.post,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Login Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'please login to access the application',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed('/languageSelection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B834F),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
