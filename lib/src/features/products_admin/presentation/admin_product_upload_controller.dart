import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/data/image_upload_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/routing/app_router.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/notifier_mounted.dart';

part 'admin_product_upload_controller.g.dart';

@riverpod
class AdminProductUploadController extends _$AdminProductUploadController
    with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
  }

  Future<void> upload(Product product) async {
    try {
      state = const AsyncLoading();

      final downloadUrl = await ref
          .read(imageUploadRepositoryProvider)
          .uploadProductImageFromAsset(product.imageUrl, product.id);

      // save downloadUrl to Firestore
      ref
          .read(productsRepositoryProvider)
          .createProduct(product.id, downloadUrl);

      // on success, go back to edit product page
      ref.read(goRouterProvider).goNamed(
        AppRoute.adminEditProduct.name,
        pathParameters: {'id': product.id},
      );
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncError(error, stackTrace);
      }
    }
  }
}
