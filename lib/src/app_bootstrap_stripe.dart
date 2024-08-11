import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:riverpod_ecommerce_app_firebase/env.dart';
import 'package:riverpod_ecommerce_app_firebase/src/app_bootstrap.dart';

extension AppBootstrapStripe on AppBootstrap {
  Future<void> setupStripe() async {
    if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
      Stripe.publishableKey = Env.stripePublishableKey;
      // https://stripe.com/gb/resources/more/merchant-id
      Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
      // https://stripe.com/docs/payments/mobile/accept-payment?platform=ios&ui=payment-sheet#ios-set-up-return-url
      Stripe.urlScheme = 'flutterstripe';
      await Stripe.instance.applySettings();
    }
  }
}
