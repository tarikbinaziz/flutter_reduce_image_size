import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery and compress it
  Future<File?> pickAndCompressImage() async {
    try {
      // Pick image from gallery
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null; // User cancelled the picker

      final File imageFile = File(pickedFile.path);

      // Compress the image
      final File? compressedImage = await compressImage(imageFile);

      return compressedImage;
    } catch (e) {
      print('Error picking or compressing image: $e');
      return null;
    }
  }

  Future<File?> compressImage(File file) async {
    try {
      // Create a new path for the compressed image
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath =
          path.join(tempDir.path, 'compressed_${path.basename(file.path)}');

      int quality = 100; // Start with maximum quality
      int targetSize =
          200 * 1024; // Target size between 100-200 KB (200 KB here)
      XFile? compressedImage;
      // Loop to decrease quality until the file size is in the desired range
      while (quality > 10) {
        compressedImage = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: quality,
          minWidth: 1200,
          minHeight: 1200,
        );

        if (compressedImage != null) {
          int fileSize = (await compressedImage.length());
          if (fileSize >= 100 * 1024 && fileSize <= targetSize) {
            break; // If file size is within the target range, break the loop
          }
        }

        quality -= 10; // Reduce quality if file size is not within range
      }

      if (compressedImage == null) {
        print('Compression failed. Compressed file is null.');
        return null;
      }
      print("mainFileSize ${file.lengthSync()}");
      print("compressedFileSize ${(File(compressedImage.path)).lengthSync()}");

      return File(compressedImage.path);
    } catch (e) {
      print('Error during compression: $e');
      return null;
    }
  }
}
