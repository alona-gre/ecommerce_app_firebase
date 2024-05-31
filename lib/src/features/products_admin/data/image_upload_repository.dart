import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';

part 'image_upload_repository.g.dart';

/// Class for uploading images to Firebase Storage
class ImageUploadRepository {
  ImageUploadRepository(this._storage);
  final FirebaseStorage _storage;

  /// Upload an image asset to Firebase Storage and returns the download URL
  Future<List<String>> uploadProductImagesFromAssets(
      List<String> assetPaths, ProductID productId) async {
    List<String> downloadUrls = [];
    for (final assetPath in assetPaths) {
// load byte from the asset bundle
      final bytes = await rootBundle.load(assetPath);

      // extract file name
      // example name: assets/products/bruschetta-plate.jpg
      final components = assetPath.split('/');
      final filename = components[2];

      // upload to firebase storage
      final result = await _uploadAsset(bytes, filename);

      // return download url
      final downloadUrl = await result.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  /// Upload an image asset to Firebase Storage and returns the download URL
  Future<String> uploadProductImageFromAsset(
      String assetPath, ProductID productId) async {
    // load byte from the asset bundle
    final bytes = await rootBundle.load(assetPath);

    // extract file name
    // example name: assets/products/bruschetta-plate.jpg
    final components = assetPath.split('/');
    final filename = components[2];

    // upload to firebase storage
    final result = await _uploadAsset(bytes, filename);

    // return download url
    return result.ref.getDownloadURL();
  }

  UploadTask _uploadAsset(ByteData byteData, String filename) {
    final bytes = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    final ref = _storage.ref('products/$filename');
    return ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
  }

  /// Delete the product image from Firebase Storage
  Future<void> deleteProductImage(List<String> imageUrls) async {
    for (final imageUrl in imageUrls) {
      try {
        await _storage.refFromURL(imageUrl).delete();
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          debugPrint('Image not found: $imageUrl.');
          return;
        } else {
          // Handle other potential exceptions
          throw Exception(e.code);
        }
      }
    }
  }
}

@riverpod
ImageUploadRepository imageUploadRepository(ImageUploadRepositoryRef ref) {
  return ImageUploadRepository(FirebaseStorage.instance);
}
