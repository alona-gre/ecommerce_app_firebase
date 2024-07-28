import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_ecommerce_app_firebase/src/constants/app_sizes.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/application/cart_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/currency_formatter.dart';

/// Text widget for showing the total price of the cart
class CartTotalText extends ConsumerWidget {
  const CartTotalText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotalAsync = ref.watch(cartTotalProvider);
    return ConstrainedBox(
      // * Use constrained box to apply the same minimum height when rendering
      // * the child widget ([Text] or [CircularProgressIndicator])
      constraints: const BoxConstraints(minHeight: Sizes.p40),
      child: AsyncValueWidget<double>(
        value: cartTotalAsync,
        data: (double cartTotal) {
          final totalFormatted =
              ref.watch(currencyFormatterProvider).format(cartTotal);
          return Text(
            'Total: $totalFormatted',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}
