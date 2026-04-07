import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/cart_bar.dart';
import '../components/product_card.dart';
import '../components/store_app_bar.dart';
import '../models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final thumb = kDemoProducts.first.imageAsset;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StoreAppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 88),
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.74,
              ),
              itemCount: kDemoProducts.length,
              itemBuilder: (context, index) {
                final product = kDemoProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
          ),
          CartBar(thumbnailAsset: thumb, itemCount: 1),
        ],
      ),
    );
  }
}
