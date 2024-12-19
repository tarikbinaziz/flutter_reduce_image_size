import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageListNotifier extends StateNotifier<List<File>> {
  ImageListNotifier() : super([]);

  void addImage(File image) {
    state = [...state, image]; // Add the new image to the state list
  }
}

final imageListProvider = StateNotifierProvider<ImageListNotifier, List<File>>(
  (ref) => ImageListNotifier(),
);
