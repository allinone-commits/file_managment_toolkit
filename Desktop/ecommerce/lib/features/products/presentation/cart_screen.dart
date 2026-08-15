import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce/core/theme.dart';
import '../controllers/product_controller.dart';
import '../presentation/category_utils.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final currency = NumberFormat.simpleCurrency();
    final width = MediaQuery.of(context).size.width;
    final wide = isWideScreen(width);

    final subtotal = cartItems.fold<double>(0, (sum, p) => sum + p.price);
    const shipping = 0.0;
    final total = subtotal + shipping;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          cartItems.isEmpty ? 'Cart' : 'Cart · ${cartItems.length}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: cartItems.isEmpty
                ? _EmptyCart(onBrowse: () => Navigator.of(context).maybePop())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            wide ? 24 : 16,
                            16,
                            wide ? 24 : 16,
                            16,
                          ),
                          itemCount: cartItems.length,
                          separatorBuilder: (context, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final product = cartItems[index];
                            return Dismissible(
                              key: ValueKey(product.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                ref
                                    .read(cartProvider.notifier)
                                    .remove(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Removed "${product.title}"'),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                  ),
                                );
                              },
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: const Icon(Icons.delete_outline,
                                    color: Colors.white),
                              ),
                              child: _CartTile(
                                title: product.title,
                                image: product.image,
                                category: readableCategory(product.category),
                                priceLabel: currency.format(product.price),
                                onRemove: () => ref
                                    .read(cartProvider.notifier)
                                    .remove(product.id),
                              ),
                            );
                          },
                        ),
                      ),
                      _OrderSummary(
                        subtotalLabel: currency.format(subtotal),
                        shippingLabel:
                            shipping == 0 ? 'Free' : currency.format(shipping),
                        totalLabel: currency.format(total),
                        wide: wide,
                        onCheckout: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final String title;
  final String image;
  final String category;
  final String priceLabel;
  final VoidCallback onRemove;

  const _CartTile({
    required this.title,
    required this.image,
    required this.category,
    required this.priceLabel,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  priceLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final String subtotalLabel;
  final String shippingLabel;
  final String totalLabel;
  final bool wide;
  final VoidCallback onCheckout;

  const _OrderSummary({
    required this.subtotalLabel,
    required this.shippingLabel,
    required this.totalLabel,
    required this.wide,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(wide ? 24 : 16, 0, wide ? 24 : 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(label: 'Subtotal', value: subtotalLabel),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Shipping', value: shippingLabel),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(totalLabel,
                  style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.background)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onBrowse;
  const _EmptyCart({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: AppColors.panel,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 44, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            const Text('Your cart is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text(
              'Items you add to your cart will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onBrowse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Start Shopping',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.background)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}