import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/snackbar_helper.dart';

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

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  XFile? _selectedVideo;
  // ignore: unused_field
  String? _selectedLocation;

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
      SnackBarHelper.showError('Limit Reached', 'Maximum 4 images allowed');
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
                      title: const Text('Choose from Gallery'),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.camera_alt,
                        color: const Color(0xFF1B834F),
                      ),
                      title: const Text('Take Photo'),
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
          imageQuality: 85,
        );
        if (image != null) {
          setState(() {
            _selectedImages.add(image);
          });
        }
      }
    } catch (e) {
      SnackBarHelper.showError(
        'Error',
        'Failed to pick image: ${e.toString()}',
      );
    }
  }

  Future<void> _pickVideo({ImageSource? source}) async {
    if (_selectedVideo != null) {
      SnackBarHelper.showError('Limit Reached', 'Maximum 1 video allowed');
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
                      title: const Text('Choose from Gallery'),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.videocam,
                        color: Color(0xFF1B834F),
                      ),
                      title: const Text('Record Video'),
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
      SnackBarHelper.showError(
        'Error',
        'Failed to pick video: ${e.toString()}',
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

  void _selectLocation() {
    // Placeholder for location selection
    // In a real app, you would integrate with Google Maps or similar
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Region'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFF1B834F),
                  ),
                  title: const Text('Nouakchott'),
                  onTap: () {
                    setState(() {
                      _selectedLocation = 'Nouakchott';
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFF1B834F),
                  ),
                  title: const Text('Nouadhibou'),
                  onTap: () {
                    setState(() {
                      _selectedLocation = 'Nouadhibou';
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFF1B834F),
                  ),
                  title: const Text('Rosso'),
                  onTap: () {
                    setState(() {
                      _selectedLocation = 'Rosso';
                    });
                    Get.back();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _handlePost() {
    if (_productNameController.text.isEmpty) {
      SnackBarHelper.showError('Validation Error', 'Please enter product name');
      return;
    }

    if (_priceController.text.isEmpty) {
      SnackBarHelper.showError('Validation Error', 'Please enter price');
      return;
    }

    if (_quantityController.text.isEmpty) {
      SnackBarHelper.showError('Validation Error', 'Please enter quantity');
      return;
    }

    if (_selectedImages.isEmpty && _selectedVideo == null) {
      SnackBarHelper.showError(
        'Validation Error',
        'Please upload at least one image or video',
      );
      return;
    }

    // For demonstration, let's toggle between showing the popup and success
    // In a real app, this would check if a package is selected
    bool hasPackage =
        _selectedImages.length > 2; // Arbitrary condition for demo

    if (hasPackage) {
      Get.toNamed('/adPostedSuccess');
    } else {
      _showPackageErrorPopup(context);
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
                const Text(
                  'Sorry !',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You don’t have an active package. Please purchase a package to post your ad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
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
                        child: const FittedBox(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
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
                        onPressed: () {
                          Get.back();
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
                        child: const FittedBox(
                          child: Text(
                            'Buy Package',
                            style: TextStyle(
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
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
          'Sell Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageUploadSection(),
            const SizedBox(height: 24),
            _buildFormFields(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Description',
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
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Select Media Type',
                                style: TextStyle(
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
                              title: const Text('Image from Gallery'),
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
                              title: const Text('Take Photo'),
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
                              title: const Text('Video from Gallery'),
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
                              title: const Text('Record Video'),
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
                        const Text(
                          'Upload Images,Videos',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Max 4 Images, 1 Video',
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
                      'Upload Images, Videos',
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
                        final choice = await showModalBottomSheet<
                          Map<String, dynamic>
                        >(
                          context: context,
                          builder:
                              (context) => SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Add Media',
                                        style: TextStyle(
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
                                        title: const Text('Image from Gallery'),
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
                                        title: const Text('Take Photo'),
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
                                        title: const Text('Video from Gallery'),
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
                                        title: const Text('Record Video'),
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

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Product Name',
          controller: _productNameController,
          hintText: '',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Price',
          controller: _priceController,
          hintText: 'Ex. 100 MRU / Kg',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Quantity',
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
        const Text(
          'Select Region',
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
            height: 90,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage(
                  'lib/assets/images/about farmer iamge.png',
                ), // Using existing image as placeholder map
                fit: BoxFit.cover,
                opacity: 0.3,
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
              child: Icon(Icons.location_on, color: Colors.red, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handlePost,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B834F),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
