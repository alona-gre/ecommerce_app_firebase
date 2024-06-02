import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/application/image_upload_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/routing/app_router.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/notifier_mounted.dart';

part 'admin_product_edit_controller.g.dart';

@riverpod
class AdminProductEditController extends _$AdminProductEditController
    with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
    // no-op
  }

  Future<bool> updateProduct({
    required Product product,
    required String title,
    required String description,
    required String price,
    required String availableQuantity,
    required List<String> updatedImageUrls,
  }) async {
    final productsRepository = ref.read(productsRepositoryProvider);
    // parse the input values (already pre-validated)
    final priceValue = double.parse(price);
    final availableQuantityValue = int.parse(availableQuantity);
    // Update product metadata (keep the pre-existing id and imageUrl)
    final updatedProduct = product.copyWith(
      title: title,
      description: description,
      price: priceValue,
      availableQuantity: availableQuantityValue,
      imageUrls: updatedImageUrls,
    );

    state = const AsyncLoading();
    final value = await AsyncValue.guard(
        () => productsRepository.updateProduct(updatedProduct));
    final success = value.hasError == false;
    if (mounted) {
      state = value;
      if (success) {
        // on success, go back to previous screen
        ref.read(goRouterProvider).pop();
      }
    }
    return success;
  }

  Future<void> deleteProduct(Product product) async {
    final imageUploadService = ref.read(imageUploadServiceProvider);
    state = const AsyncLoading();
    final value =
        await AsyncValue.guard(() => imageUploadService.deleteProduct(product));
    final success = value.hasError == false;
    if (mounted) {
      state = value;
      if (success) {
        // on success, go back to the previous screen
        ref.read(goRouterProvider).pop();
      }
    }
  }
}
