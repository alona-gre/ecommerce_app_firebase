import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce_app_firebase/src/common_widgets/primary_button.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:riverpod_ecommerce_app_firebase/src/localization/string_hardcoded.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/async_value_ui.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends ConsumerWidget {
  const PaymentButton({super.key});

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    ref.read(paymentButtonControllerProvider.notifier).pay();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      paymentButtonControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(paymentButtonControllerProvider);
    return PrimaryButton(
      text: 'Pay'.hardcoded,
      isLoading: state.isLoading,
      onPressed: state.isLoading ? null : () => _pay(context, ref),
    );
  }
}
