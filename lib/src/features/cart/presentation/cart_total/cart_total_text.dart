import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/application/cart_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/currency_formatter.dart';

/// Text widget for showing the total price of the cart
class CartTotalText extends ConsumerWidget {
  const CartTotalText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotal = ref.watch(cartTotalProvider);
    final totalFormatted =
        ref.watch(currencyFormatterProvider).format(cartTotal);
    return Text(
      'Total: $totalFormatted',
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    );
  }
}
