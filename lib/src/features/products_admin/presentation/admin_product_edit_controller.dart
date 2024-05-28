import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/application/image_upload_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/data/image_upload_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/routing/app_router.dart';

part 'admin_product_edit_controller.g.dart';

@riverpod
class AdminProductEditController extends _$AdminProductEditController {
  FutureOr<void> build() {
    // nothing to do
  }

  Future<bool> updateProduct({
    required Product product,
    required String title,
    required String description,
    required String price,
    required String availableQuantity,
  }) async {
    final productsRepository = ref.read(productsRepositoryProvider);
    // parse the input values (alreadypre-validated)
    final priceValue = double.parse(price);
    final availableQuantityValue = int.parse(availableQuantity);
    final updatedProduct = product.copyWith(
      title: title,
      description: description,
      price: priceValue,
      availableQuantity: availableQuantityValue,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(productsRepositoryProvider).updateProduct(updatedProduct));
    final success = state.hasError == false;
    // on success, go back to the previous screen
    if (success) {
      ref.read(goRouterProvider).pop();
    }
    return success;
  }

  Future<bool> deleteProduct(Product product) async {
    final imageUploadService = ref.read(imageUploadServiceProvider);
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => imageUploadService.deleteProduct(product));
    final success = state.hasError == false;
    // on success, go back to the previous screen
    if (success) {
      ref.read(goRouterProvider).pop();
    }
    return success;
  }
}
