import 'package:riverpod_ecommerce_app_firebase/src/features/products/presentation/products_list/sliver_products_grid.dart';
import 'package:riverpod_ecommerce_app_firebase/src/localization/string_hardcoded.dart';
import 'package:riverpod_ecommerce_app_firebase/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Used to add or edit products
class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Products'.hardcoded)),
      body: CustomScrollView(
        slivers: [
          SliverProductsGrid(
            onPressed: (context, productId) => context.goNamed(
              AppRoute.adminEditProduct.name,
              pathParameters: {'id': productId},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.goNamed(AppRoute.adminAdd.name),
      ),
    );
  }
}
