import 'dart:io';

import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/action_text_button.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/carousel_slider.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/custom_text_button.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/error_message_widget.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/responsive_center.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/responsive_two_column_layout.dart';
import 'package:riverpod_ecommerce_app_firebase/src/constants/app_sizes.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/data/image_upload_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/data/template_products_providers.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/presentation/admin_product_edit_controller.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/presentation/product_validator.dart';
import 'package:riverpod_ecommerce_app_firebase/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/async_value_ui.dart';

/// Widget screen for updating existing products (edit mode).
/// Products are first created inside [AdminProductUploadScreen].
class AdminProductEditScreen extends ConsumerWidget {
  const AdminProductEditScreen({super.key, required this.productId});
  final ProductID productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // * By watching a [FutureProvider], the data is only loaded once.
    // * This prevents unintended rebuilds while the user is entering form data
    final productValue = ref.watch(productFutureProvider(productId));
    // * Using .when rather than [AsyncValueWidget] to provide custom error and
    // * loading screens
    return productValue.when(
      data: (product) => product != null
          ? AdminProductEditScreenContents(product: product)
          : Scaffold(
              appBar: AppBar(title: Text('Edit Product'.hardcoded)),
              body: Center(
                child: ErrorMessageWidget('Product not found'.hardcoded),
              ),
            ),
      // * to prevent a black screen, return a [Scaffold] from the error and
      // * loading screens
      error: (e, st) =>
          Scaffold(body: Center(child: ErrorMessageWidget(e.toString()))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

/// Widget containing most of the UI for editing a product
class AdminProductEditScreenContents extends ConsumerStatefulWidget {
  const AdminProductEditScreenContents({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<AdminProductEditScreenContents> createState() =>
      _AdminProductScreenContentsState();
}

class _AdminProductScreenContentsState
    extends ConsumerState<AdminProductEditScreenContents> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _availableQuantityController = TextEditingController();

  Product get product => widget.product;

  List<File> _newlyAddedImages = [];
  late List<String> _copiedImageUrls;

  @override
  void initState() {
    super.initState();
    // Initialize text fields with product data
    _titleController.text = product.title;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _availableQuantityController.text = product.availableQuantity.toString();

    // Store a copy of the initial image URLs
    _copiedImageUrls = List.unmodifiable(product.imageUrls);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _availableQuantityController.dispose();
    super.dispose();
  }

  Future<void> _loadFromTemplate() async {
    final template = await ref.read(templateProductProvider(product.id).future);
    if (template != null) {
      _titleController.text = template.title;
      _descriptionController.text = template.description;
      _priceController.text = template.price.toString();
      _availableQuantityController.text = template.availableQuantity.toString();
      _formKey.currentState!.validate();
    }
  }

  Future<void> _delete() async {
    final delete = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );
    if (delete == true) {
      ref
          .read(adminProductEditControllerProvider.notifier)
          .deleteProduct(product);
    }
  }

  // add new images to existing imageUrls, they will be sent to Firestore
  List<String> updatedImageUrls(List<String> newImagesDownloadedUrls) {
    final currentImageUrls = product.imageUrls;
    for (final imageUrl in newImagesDownloadedUrls) {
      currentImageUrls.add(imageUrl);
    }
    return currentImageUrls;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // send addedImages to the storage and get urls
      final newImagesDownloadedUrls = await ref
          .read(imageUploadRepositoryProvider)
          .uploadProductImagesFromFiles(
            _newlyAddedImages,
            product.id,
          );

      final updatedImages = updatedImageUrls(newImagesDownloadedUrls);

      final success = await ref
          .read(adminProductEditControllerProvider.notifier)
          .updateProduct(
            product: product,
            title: _titleController.text,
            description: _descriptionController.text,
            price: _priceController.text,
            availableQuantity: _availableQuantityController.text,
            updatedImageUrls: updatedImages,
          );
      if (success) {
        // Inform the user that the product has been updated
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Product updated'.hardcoded,
            ),
          ),
        );
      }

      // TODO: Delete files from storage that are not in updatedImages;
      final imageUrlstoRemove =
          _copiedImageUrls.toSet().difference(updatedImages.toSet());

      await ref
          .read(imageUploadRepositoryProvider)
          .deleteProductImage(imageUrlstoRemove.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      adminProductEditControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(adminProductEditControllerProvider);
    final isLoading = state.isLoading;
    const autovalidateMode = AutovalidateMode.disabled;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'.hardcoded),
        actions: [
          ActionTextButton(
            text: 'Save'.hardcoded,
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Form(
            key: _formKey,
            child: ResponsiveTwoColumnLayout(
              startContent: Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: CarouselSliderEdit(
                    imageUrls: product.imageUrls,
                    onPreviewedImages: (addedImages) {
                      _newlyAddedImages = addedImages;
                    },
                  ),
                ),
              ),
              spacing: Sizes.p16,
              endContent: Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          label: Text('Title'.hardcoded),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator:
                            ref.read(productValidatorProvider).titleValidator,
                      ),
                      gapH8,
                      TextFormField(
                        controller: _descriptionController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          label: Text('Description'.hardcoded),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator: ref
                            .read(productValidatorProvider)
                            .descriptionValidator,
                      ),
                      gapH8,
                      TextFormField(
                        controller: _priceController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          label: Text('Price'.hardcoded),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator:
                            ref.read(productValidatorProvider).priceValidator,
                      ),
                      gapH8,
                      TextFormField(
                        controller: _availableQuantityController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          label: Text('Available Quantity'.hardcoded),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator: ref
                            .read(productValidatorProvider)
                            .availableQuantityValidator,
                      ),
                      gapH16,
                      const Divider(),
                      gapH8,
                      EditProductOptions(
                        onLoadFromTemplate:
                            isLoading ? null : _loadFromTemplate,
                        onDelete: isLoading ? null : _delete,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Responsive widget with options to preload product data and delete a product
class EditProductOptions extends StatelessWidget {
  const EditProductOptions(
      {super.key, required this.onLoadFromTemplate, required this.onDelete});
  final VoidCallback? onLoadFromTemplate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ResponsiveTwoColumnLayout(
      rowMainAxisAlignment: MainAxisAlignment.center,
      startContent: CustomTextButton(
        text: 'Load from Template'.hardcoded,
        style: Theme.of(context).textTheme.titleSmall,
        onPressed: onLoadFromTemplate,
      ),
      endContent: CustomTextButton(
        text: 'Delete Product'.hardcoded,
        style:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.red),
        onPressed: onDelete,
      ),
      spacing: Sizes.p8,
    );
  }
}
