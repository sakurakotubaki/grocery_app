import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/product.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// アプリ全体の [GoRouter]。認証や他プロバイダに依存させる場合はここで `ref.watch` する。
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final product = productById(id);
          if (product == null) {
            return const _UnknownProductScreen();
          }
          return ProductDetailScreen(product: product);
        },
      ),
    ],
  );
}

class _UnknownProductScreen extends StatelessWidget {
  const _UnknownProductScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: const Center(child: Text('Product not found')),
    );
  }
}
