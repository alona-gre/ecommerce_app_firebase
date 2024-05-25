import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/custom_image.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/error_message_widget.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/primary_button.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/responsive_center.dart';
import 'package:riverpod_ecommerce_app_firebase/src/constants/app_sizes.dart';
import 'package:riverpod_ecommerce_app_firebase/src/constants/breakpoints.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/data/template_products_providers.dart';
import 'package:riverpod_ecommerce_app_firebase/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Used to upload a product to cloud storage
class AdminProductUploadScreen extends StatelessWidget {
  const AdminProductUploadScreen({super.key, required this.productId});
  final ProductID productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a product'.hardcoded),
      ),
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: AdminProductUpload(productId: productId),
      ),
    );
  }
}

class AdminProductUpload extends ConsumerWidget {
  const AdminProductUpload({super.key, required this.productId});
  final ProductID productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Uncomment
    // ref.listen<AsyncValue>(
    //   adminProductUploadControllerProvider,
    //   (_, state) => state.showAlertDialogOnError(context),
    // );
    // // State of the upload operation
    // final state = ref.watch(adminProductUploadControllerProvider);
    // final isLoading = state.isLoading;
    const isLoading = false;
    // Product to be uploaded
    final templateProductValue = ref.watch(templateProductProvider(productId));
    return AsyncValueWidget<Product?>(
      value: templateProductValue,
      data: (templateProduct) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (templateProduct != null) ...[
                CustomImage(imageUrl: templateProduct.imageUrl),
                gapH16,
                PrimaryButton(
                  text: 'Upload'.hardcoded,
                  isLoading: isLoading,
                  onPressed: () => showAlertDialog(
                    context: context,
                    title: 'Not implemented'.hardcoded,
                  ),
                  // TODO: Uncomment
                  // onPressed: isLoading
                  //     ? null
                  //     : () => ref
                  //         .read(adminProductUploadControllerProvider.notifier)
                  //         .upload(templateProduct),
                ),
              ] else
                ErrorMessageWidget(
                    'Product template not found for ID: $productId'),
            ],
          ),
        ),
      ),
    );
  }
}