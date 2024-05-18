import 'package:riverpod_ecommerce_app_firebase/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/application/cart_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/data/local/local_cart_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/checkout/application/fake_checkout_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/orders/data/fake_orders_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/fake_products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/reviews/application/fake_reviews_service.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockRemoteCartRepository extends Mock
    implements FakeRemoteCartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockCartService extends Mock implements CartService {}

class MockProductsRepository extends Mock implements FakeProductsRepository {}

class MockOrdersRepository extends Mock implements FakeOrdersRepository {}

class MockCheckoutService extends Mock implements FakeCheckoutService {}

class MockReviewsRepository extends Mock implements FakeReviewsRepository {}

class MockReviewsService extends Mock implements FakeReviewsService {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
