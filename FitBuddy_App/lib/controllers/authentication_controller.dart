import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AuthenticationController extends GetxController{
  static AuthenticationController authController = Get.find();

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;

  packageImageFileFromGallery() async{
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(imageFile != null){
      Get.snackbar("Profile Image","you have successfully picked your profile image");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  captureImageFromCamera() async{
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if(imageFile != null){
      Get.snackbar("Profile Image","you have successfully picked your profile image");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }
}