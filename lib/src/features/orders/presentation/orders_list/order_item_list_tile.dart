import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/custom_image.dart';
import 'package:riverpod_ecommerce_app_firebase/src/constants/app_sizes.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/domain/item.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';
import 'package:riverpod_ecommerce_app_firebase/src/localization/string_hardcoded.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends ConsumerWidget {
  const OrderItemListTile({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productStreamProvider(item.productId));
    return AsyncValueWidget<Product?>(
      value: productValue,
      data: (product) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: CustomImage(imageUrl: product!.imageUrls[0]),
            ),
            gapW8,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title),
                  gapH12,
                  Text(
                    'Quantity: ${item.quantity}'.hardcoded,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
