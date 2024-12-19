import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_size_reduce/utis/image_compressor.dart';
import 'package:flutter_image_size_reduce/utis/image_store_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageGalleryScreen extends ConsumerWidget {
  final ImageUtils _imageUtils = ImageUtils();

  ImageGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageList = ref.watch(imageListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Image Gallery")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final File? compressedImage =
                  await _imageUtils.pickAndCompressImage();
              if (compressedImage != null) {
                ref.read(imageListProvider.notifier).addImage(compressedImage);
              }
            },
            child: const Text("Pick and Compress Image"),
          ),
          Expanded(
            child: imageList.isEmpty
                ? const Center(child: Text("No images selected"))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(imageList[index], fit: BoxFit.cover),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
