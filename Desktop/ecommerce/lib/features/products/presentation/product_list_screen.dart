import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce/core/theme.dart';
import '../controllers/product_controller.dart';
import 'category_utils.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _query = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final cartCount = ref.watch(cartCountProvider);
    final currency = NumberFormat.simpleCurrency();

    final width = MediaQuery.of(context).size.width;
    final wide = isWideScreen(width);
    final columns = gridColumnsForWidth(width);
    final aspectRatio = gridAspectRatioForColumns(columns);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: wide ? 24 : 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Discover',
                                style: TextStyle(
                                    fontSize: wide ? 34 : 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 6),
                            const Text('Find your perfect product',
                                style: TextStyle(
                                    fontSize: 16, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const CartScreen()));
                        },
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.shopping_cart_outlined,
                                  color: AppColors.textPrimary),
                              if (cartCount > 0)
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: Text(cartCount.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: wide ? 24 : 16, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: AppColors.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          elevation: 0,
                          child: TextField(
                            onChanged: (v) => setState(() => _query = v),
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                              hintText: 'Search products',
                              hintStyle: const TextStyle(color: AppColors.textSecondary),
                              border: InputBorder.none,
                              suffixIcon: _query.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                                      onPressed: () => setState(() => _query = ''))
                                  : null,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list, color: AppColors.background),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: categoriesAsync.when(
                    data: (categories) {
                      final chips = ['All', ...categories];
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: chips.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = chips[index];
                          final label =
                              category == 'All' ? 'All' : readableCategory(category);
                          return ChoiceChip(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            label: Text(label),
                            selected: _selectedCategory == category,
                            selectedColor: AppColors.accent,
                            backgroundColor: AppColors.panel,
                            labelStyle: TextStyle(
                                color: _selectedCategory == category
                                    ? AppColors.background
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            onSelected: (_) => setState(() => _selectedCategory = category),
                          );
                        },
                      );
                    },
                    loading: () => ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => Container(
                          width: 90,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6))
                              ])),
                    ),
                    error: (_, _) => ListView(
                      padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 16),
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 4),
                        ChoiceChip(
                            label: const Text('All'),
                            selected: true,
                            selectedColor: AppColors.accent,
                            backgroundColor: AppColors.surface,
                            labelStyle: const TextStyle(color: AppColors.background),
                            onSelected: (_) {}),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: productsAsync.when(
                    data: (products) {
                      final filtered = products.where((p) {
                        final matchesQuery = _query.isEmpty ||
                            p.title.toLowerCase().contains(_query.toLowerCase());
                        final matchesCategory =
                            _selectedCategory == 'All' || p.category == _selectedCategory;
                        return matchesQuery && matchesCategory;
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.search_off,
                                  size: 40, color: AppColors.textSecondary),
                              const SizedBox(height: 12),
                              const Text('No products found',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                  onPressed: () => ref.refresh(productsProvider),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: const Text('Retry')),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await Future.wait([
                            ref.refresh(categoriesProvider.future),
                            ref.refresh(productsProvider.future),
                          ]);
                        },
                        color: AppColors.accent,
                        child: GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                              wide ? 24 : 16, 12, wide ? 24 : 16, 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final p = filtered[index];
                            return _ProductCard(
                        title: p.title,
                        image: p.image,
                        category: readableCategory(p.category),
                        rating: p.rating,
                        priceLabel: currency.format(p.price),
                        isFavorite: favoriteIds.contains(p.id),
                        heroTag: 'product_${p.id}',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
                        onToggleFavorite: () =>
                            ref.read(favoritesProvider.notifier).toggle(p.id),
                      );
                          },
                        ),
                      );
                    },
                    loading: () => _buildShimmerGrid(columns, aspectRatio, wide),
                    error: (e, st) => Center(
                        child: Text('Unable to load products. ${e.toString()}',
                            style: const TextStyle(color: Colors.redAccent))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(int columns, double aspectRatio, bool wide) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 12, wide ? 24 : 16, 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: columns * 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[850]!,
          highlightColor: Colors.grey[800]!,
          child: Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Container(
                  height: 170,
                  decoration: BoxDecoration(
                      color: AppColors.panel,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
              const SizedBox(height: 14),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 14.0), child: Container(height: 14, color: AppColors.panel)),
              const SizedBox(height: 8),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 14.0), child: Container(height: 14, width: 80, color: AppColors.panel)),
            ]),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String image;
  final String category;
  final double rating;
  final String priceLabel;
  final bool isFavorite;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const _ProductCard({
    required this.title,
    required this.image,
    required this.category,
    required this.rating,
    required this.priceLabel,
    required this.isFavorite,
    required this.heroTag,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: heroTag,
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          color: AppColors.panel),
                      child: Center(child: Image.network(image, height: 120, fit: BoxFit.contain)),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite ? Colors.redAccent : AppColors.textSecondary,
                        ),
                        onPressed: onToggleFavorite,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColors.panel, borderRadius: BorderRadius.circular(14)),
                      child: Text(category,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 10),
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, height: 1.3)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 6),
                          Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ]),
                        Text(priceLabel, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
