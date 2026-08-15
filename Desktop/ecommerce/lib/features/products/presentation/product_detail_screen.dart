import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce/core/theme.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../presentation/category_utils.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = NumberFormat.simpleCurrency();
    final cartItems = ref.watch(cartProvider);
    final inCart = cartItems.any((item) => item.id == product.id);
    final width = MediaQuery.of(context).size.width;
    final wide = isWideScreen(width);

    void handleAddToCart() {
      if (!inCart) {
        ref.read(cartProvider.notifier).add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${product.title}" to cart'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already in cart'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: wide
              ? _WideLayout(
                  product: product,
                  currency: currency,
                  inCart: inCart,
                  onAddToCart: handleAddToCart,
                )
              : _NarrowLayout(
                  product: product,
                  currency: currency,
                  inCart: inCart,
                  onAddToCart: handleAddToCart,
                ),
        ),
      ),
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final Product product;
  final NumberFormat currency;
  final bool inCart;
  final VoidCallback onAddToCart;

  const _NarrowLayout({
    required this.product,
    required this.currency,
    required this.inCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductHero(product: product, height: 340),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _ProductInfo(product: product, currency: currency),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BuyBar(
            priceLabel: currency.format(product.price),
            inCart: inCart,
            onPressed: onAddToCart,
          ),
        ),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  final Product product;
  final NumberFormat currency;
  final bool inCart;
  final VoidCallback onAddToCart;

  const _WideLayout({
    required this.product,
    required this.currency,
    required this.inCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: _ProductHero(product: product, height: 460, radius: 32),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductInfo(product: product, currency: currency),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(inCart ? 'In Cart' : 'Add to Cart',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.background)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  final Product product;
  final double height;
  final double radius;

  const _ProductHero({required this.product, required this.height, this.radius = 36});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_${product.id}',
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: Center(child: Image.network(product.image, height: height * 0.82, fit: BoxFit.contain)),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;
  final NumberFormat currency;

  const _ProductInfo({required this.product, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(16)),
          child: Text(readableCategory(product.category),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 14),
        Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.25)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 6),
              Text('${product.rating.toStringAsFixed(1)} (${product.ratingCount})',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ]),
            Text(currency.format(product.price), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Product Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Text(product.description, style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('Delivery', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    SizedBox(height: 6),
                    Text('Free 2-day shipping', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ]),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('Quality', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    SizedBox(height: 6),
                    Text('Premium materials', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ]),
                ),
              ])
            ],
          ),
        ),
        const SizedBox(height: 26),
      ],
    );
  }
}

class _BuyBar extends StatelessWidget {
  final String priceLabel;
  final bool inCart;
  final VoidCallback onPressed;

  const _BuyBar({required this.priceLabel, required this.inCart, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 14, offset: const Offset(0, -4))],
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Total', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text(priceLabel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: AppColors.accent,
          ),
          child: Text(inCart ? 'In Cart' : 'Add to Cart', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.background)),
        )
      ]),
    );
  }
}
