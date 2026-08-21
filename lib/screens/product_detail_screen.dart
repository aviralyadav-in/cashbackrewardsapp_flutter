import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/network_image_with_skeleton.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-detail';

  final Product? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product ??
        ModalRoute.of(context)?.settings.arguments as Product?;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(
          child: Text('Product details not found.'),
        ),
      );
    }

    final imageList = (product.images != null && product.images!.isNotEmpty)
        ? product.images!
        : [product.thumbnail];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE CAROUSEL / DISPLAY
                  Container(
                    width: double.infinity,
                    height: 280,
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: imageList.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: NetworkImageWithSkeleton(
                                  imageUrl: imageList[index],
                                  fit: BoxFit.contain,
                                  borderRadius: BorderRadius.circular(16),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: isDark
                                          ? const Color(0xFF242426)
                                          : Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        if (imageList.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                imageList.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: _currentImageIndex == index ? 20 : 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == index
                                        ? const Color(0xFF1E90FF)
                                        : (isDark ? Colors.white38 : Colors.black26),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // MAIN PRODUCT HEADER CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BRAND & RATING ROW
                        Row(
                          children: [
                            if (product.brand != null && product.brand!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E90FF).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product.brand!.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF1E90FF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            if (product.brand != null && product.brand!.isNotEmpty)
                              const SizedBox(width: 8),
                            if (product.category != null && product.category!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF28282A) : const Color(0xFFF0F2F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product.category!,
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            if (product.rating != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating!.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // PRODUCT TITLE
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // PRICING INFORMATION CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pricing Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // FINAL / SELLING PRICE
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Final Price',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '\$${product.finalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.green.shade400 : Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 20),

                            // ACTUAL / ORIGINAL PRICE
                            if (product.discountPercentage > 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Original Price',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$${product.originalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),

                            const Spacer(),

                            // DISCOUNT PERCENTAGE BADGE
                            if (product.discountPercentage > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green.shade300),
                                ),
                                child: Text(
                                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DESCRIPTION & SPECIFICATIONS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                              ),
                        ),
                        if (product.stock != null || product.sku != null) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (product.stock != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Stock',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${product.stock} available',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: (product.stock! < 10)
                                              ? Colors.orange
                                              : (isDark ? Colors.white : Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (product.sku != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'SKU',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.sku!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // BOTTOM ACTION BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161618) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Redirecting to store deal for ${product.title}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Shop Now & Earn Cashback',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
