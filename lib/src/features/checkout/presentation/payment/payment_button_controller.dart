import 'dart:async';

import 'package:riverpod_ecommerce_app_firebase/src/features/checkout/application/fake_checkout_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/utils/notifier_mounted.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_button_controller.g.dart';

@riverpod
class PaymentButtonController extends _$PaymentButtonController
    with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
    // nothing to do
  }

  Future<void> pay() async {
    final checkoutService = ref.read(checkoutServiceProvider);
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(checkoutService.placeOrder);
    // * Check if the controller is mounted before setting the state to prevent:
    // * Bad state: Tried to use PaymentButtonController after `dispose` was called.
    if (mounted) {
      state = newState;
    }
  }
}
