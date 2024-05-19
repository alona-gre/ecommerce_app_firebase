import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/data/products_repository.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';

part 'products_search_state_provider.g.dart';

// * Riverpod generator doesn't support StateProvider so we use the old syntax
final productsSearchQueryStateProvider = StateProvider<String>((ref) {
  return '';
});

@riverpod
Future<List<Product>> productsSearchResults(ProductsSearchResultsRef ref) {
  final searchQuery = ref.watch(productsSearchQueryStateProvider);
  return ref.watch(productsListSearchProvider(searchQuery).future);
}
