import 'dart:io';

import 'package:flutter_chat_app/shared/usecase/image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUseCase {
  final ImageCompressUseCase imageCompressUseCase;

  ImageUseCase({required this.imageCompressUseCase});
  Future<void> getImageFromGallery(Function(File? file) compressedImage) async {
    final imagePicker = ImagePicker();
    XFile? image;
    if (Platform.isIOS) {
      final permissionStatus = await Permission.photos.isGranted ||
          await Permission.photos.isLimited;
      if (permissionStatus) {
        image = await imagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 5);
        if (image != null) {
          // await imageCompressUseCase.compressImage(image.path, (file) {
          //   compressedImage(file);
          // });
          compressedImage(File(image.path));
        }
      } else {
        bool hasPermission = await Permission.photos.request().isGranted ||
            await Permission.photos.request().isLimited;
        if (hasPermission) {
          image = await imagePicker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            // await imageCompressUseCase.compressImage(image.path, (file) {
            //   compressedImage(file);
            // });
            compressedImage(File(image.path));
          }
        }
      }
    }
  }
}
