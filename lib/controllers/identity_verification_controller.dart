import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IdentityVerificationController extends GetxController {
  final RxList<XFile> nationalIDProofs = <XFile>[].obs;
  final RxList<XFile> businessCertificates = <XFile>[].obs;
  final RxList<XFile> farmCertificates = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
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

  bool get isSubmitEnabled =>
      nationalIDProofs.isNotEmpty && businessCertificates.isNotEmpty;
}
