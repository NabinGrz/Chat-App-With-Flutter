import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressUseCase {
  Future<void> compressImage(
      String filePath, Function(File? file) onCompressed) async {
    await FlutterImageCompress.compressWithFile(filePath, quality: 5)
        .then((value) {
      if (value != null) {
        onCompressed(File.fromRawPath(value));
      }
    });
  }
}
