import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';

part 'products_repository.g.dart';

class ProductsRepository {
  final FirebaseFirestore _firestore;
  ProductsRepository(this._firestore);

  static String productsPath() => 'products';
  static String productPath(ProductID id) => 'products/$id';

  DocumentReference<Product> _productRef(ProductID id) =>
      _firestore.doc(productPath(id)).withConverter(
            fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
            toFirestore: (Product product, options) => product.toMap(),
          );

  Query<Product> _productsRef() => _firestore
      .collection(productsPath())
      .withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
        toFirestore: (Product product, options) => product.toMap(),
      )
      .orderBy('id');

  Future<List<Product>> fetchProductsList() async {
    final ref = _productsRef();
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Stream<List<Product>> watchProductsList() {
    final ref = _productsRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Stream<Product?> watchProduct(ProductID id) {
    final ref = _productRef(id);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  Future<Product?> fetchProduct(ProductID id) async {
    final ref = _productRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

// * Temporary search implementation.
  // * Note: this is quite inefficient as it pulls the entire product list
  // * and then filters the data on the client
  // TODO: Update
  Future<List<Product>> searchProducts(String query) async {
    // 1. Get all products from Firestore
    final productsList = await fetchProductsList();
    // 2. Perform client-side filtering
    return productsList
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> createProduct(ProductID id, List<String> imageUrls) {
    return _firestore.doc(productPath(id)).set(
      {
        'id': id,
        'imageUrls': imageUrls,
      },
      // use merge: true to  keep old  fields (if any)
      SetOptions(merge: true),
    );
  }

  Future<void> updateProduct(Product product) {
    final ref = _productRef(product.id);
    return ref.set(product);
  }

  Future<void> deleteProduct(ProductID id) {
    return _firestore.doc(productPath(id)).delete();
  }
}

@Riverpod(keepAlive: true)
ProductsRepository productsRepository(ProductsRepositoryRef ref) {
  return ProductsRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Product>> productsListStream(ProductsListStreamRef ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
}

@riverpod
Future<List<Product>> productsListFuture(ProductsListFutureRef ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductsList();
}

@riverpod
Stream<Product?> productStream(ProductStreamRef ref, ProductID id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
}

@riverpod
Future<Product?> productFuture(ProductFutureRef ref, ProductID id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProduct(id);
}

@riverpod
Future<List<Product>> productsListSearch(
    ProductsListSearchRef ref, String query) async {
  final link = ref.keepAlive();
  // a timer to be used by the callbacks below
  Timer? timer;
  // When the provider is destroyed, cancel the http request and the timer
  ref.onDispose(() {
    timer?.cancel();
  });
  // When the last listener is removed, start a timer to dispose the cached data
  ref.onCancel(() {
    // start a 30 second timer
    timer = Timer(const Duration(seconds: 30), () {
      // dispose on timeout
      link.close();
    });
  });
  // If the provider is listened again after it was paused, cancel the timer
  ref.onResume(() {
    timer?.cancel();
  });
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.searchProducts(query);
}
