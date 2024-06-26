import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/domain/cart.dart';

part 'local_cart_repository.g.dart';

/// API for reading, watching and writing local cart data (guest user)
abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Stream<Cart> watchCart();

  Future<void> setCart(Cart cart);
}

@Riverpod(keepAlive: true)
LocalCartRepository localCartRepository(LocalCartRepositoryRef ref) {
  throw UnimplementedError();
}
