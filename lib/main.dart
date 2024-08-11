import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_ecommerce_app_firebase/firebase_options.dart';
import 'package:riverpod_ecommerce_app_firebase/src/app_bootstrap.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:riverpod_ecommerce_app_firebase/src/app_bootstrap_firebase.dart';
import 'package:riverpod_ecommerce_app_firebase/src/app_bootstrap_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // create an app bootstrap instance
  final appBootstrap = AppBootstrap();
  // connect to Firebase emulators
  // appBootstrap.setupEmulators();
  // Stripe setup
  await appBootstrap.setupStripe();
  // create a container configured with all the Firebase repositories
  final container = await appBootstrap.createFirebaseProviderContainer();
  // use the container above to create the root widget
  final root = appBootstrap.createRootWidget(container: container);
  // start the app
  runApp(root);
}
