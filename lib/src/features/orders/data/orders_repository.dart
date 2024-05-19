import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/orders/domain/order.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';

part 'orders_repository.g.dart';

// TODO: Implement with Firebase
abstract class OrdersRepository {
  Stream<List<Order>> watchUserOrders(UserID uid, {ProductID? productId});
}

@Riverpod(keepAlive: true)
OrdersRepository ordersRepository(OrdersRepositoryRef ref) {
  // TODO: create and return repository
  throw UnimplementedError();
}
