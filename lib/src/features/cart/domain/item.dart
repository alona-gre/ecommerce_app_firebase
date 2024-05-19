import 'package:equatable/equatable.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';

/// A product along with a quantity that can be added to an order/cart
class Item extends Equatable {
  const Item({
    required this.productId,
    required this.quantity,
  });
  final ProductID productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];

  @override
  bool? get stringify => true;
}
