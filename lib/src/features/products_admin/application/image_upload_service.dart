import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/data/image_upload_repository.dart';

part 'image_upload_service.g.dart';

class ImageUploadService {
  final Ref ref;
  ImageUploadService(this.ref);

  Future<void> uploadProduct(Product product) async {
    // upload to storage and return downloadUrl
    final downloadUrls = await ref
        .read(imageUploadRepositoryProvider)
        .uploadProductImagesFromAssets(product.imageUrls, product.id);

    // save id and downloadUrl to Firestore
    ref
        .read(productsRepositoryProvider)
        .createProduct(product.id, downloadUrls);
  }

  Future<void> deleteProduct(Product product) async {
    // delete an image from storage
    await ref
        .read(imageUploadRepositoryProvider)
        .deleteProductImage(product.imageUrls);

    // delete product data from Firestore
    ref.read(productsRepositoryProvider).deleteProduct(product.id);
  }
}

@riverpod
ImageUploadService imageUploadService(ImageUploadServiceRef ref) {
  return ImageUploadService(ref);
}
