import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/cart/domain/cart.dart';

part 'remote_cart_repository.g.dart';

/// API for reading, watching and writing cart data for a specific user ID
// TODO: Implement with Firebase
abstract class RemoteCartRepository {
  Future<Cart> fetchCart(UserID uid);

  Stream<Cart> watchCart(UserID uid);

  Future<void> setCart(UserID uid, Cart cart);
}

@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(RemoteCartRepositoryRef ref) {
  // TODO: create and return repository
  throw UnimplementedError();
}
