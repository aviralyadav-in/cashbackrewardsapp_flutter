import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import '../providers/product_detail_provider.dart';

class OfferDetailsScreen extends StatefulWidget {
  static const String routeName = '/offer-details';

  final int productId;

  const OfferDetailsScreen({super.key, required this.productId});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  // bool _didFetch = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_didFetch) {
  //     _didFetch = true;
  //     context.read<ProductDetailProvider>().fetchProductDetail(
  //       widget.productId,
  //     );
  //   }
  // }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailProvider>().fetchProductDetail(
        widget.productId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Details'),
        actions: [
          Consumer2<FavoriteProvider, ProductDetailProvider>(
            builder: (context, favoriteProvider, detailProvider, child) {
              final isFavorite = favoriteProvider.isFavorite(widget.productId);

              return IconButton(
                onPressed: () {
                  final detail = detailProvider.productDetail;
                  final product = (detail != null && detail.id == widget.productId)
                      ? detail.toProduct()
                      : null;

                  favoriteProvider.toggleFavoriteProductId(
                    widget.productId,
                    product: product,
                  );
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductDetailProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case ProductDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProductDetailStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        provider.errorMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            provider.fetchProductDetail(widget.productId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            case ProductDetailStatus.loaded:
              final detail = provider.productDetail;
              if (detail == null) {
                return const Center(child: Text('Product details unavailable'));
              }

              final imageUrl = detail.images.isNotEmpty
                  ? detail.images.first
                  : detail.thumbnail;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 240,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      detail.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detail.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Product Information'),
                    _buildInfoRow('Category', detail.category),
                    _buildInfoRow('Brand', detail.brand),
                    _buildInfoRow('SKU', detail.sku),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Pricing Information'),
                    _buildInfoRow('Price', '\$${detail.price}'),
                    _buildInfoRow(
                      'Discount',
                      '-${detail.discountPercentage.toStringAsFixed(0)}%',
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Product Status'),
                    _buildInfoRow('Rating', detail.rating.toStringAsFixed(1)),
                    _buildInfoRow('Stock', detail.stock.toString()),
                    _buildInfoRow('Availability', detail.availabilityStatus),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Additional Information'),
                    _buildInfoRow(
                      'Weight',
                      detail.weight > 0
                          ? '${detail.weight} g'
                          : 'Not available',
                    ),
                    _buildInfoRow('Dimensions', detail.dimensions),
                    _buildInfoRow(
                      'Minimum Order',
                      detail.minimumOrderQuantity.toString(),
                    ),
                    _buildInfoRow('Warranty', detail.warrantyInformation),
                    _buildInfoRow('Shipping', detail.shippingInformation),
                    _buildInfoRow('Return', detail.returnPolicy),
                    const SizedBox(height: 16),
                    if (detail.tags.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Tags'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: detail.tags
                            .map(
                              (tag) => Chip(
                                label: Text(
                                  tag,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                side: BorderSide(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF2E2E2E)
                                      : const Color(0xFFE5E5EA),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildSectionTitle(context, 'Customer Reviews'),
                    if (detail.reviews.isEmpty)
                      const Text('No reviews available yet.')
                    else
                      Column(
                        children: detail.reviews
                            .map(
                              (review) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.reviewerName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber.shade700,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              review.rating.toStringAsFixed(1),
                                            ),
                                            const Spacer(),
                                            Text(
                                              review.date != null
                                                  ? '${review.date!.year}-${review.date!.month.toString().padLeft(2, '0')}-${review.date!.day.toString().padLeft(2, '0')}'
                                                  : 'Unknown date',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(review.comment),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            case ProductDetailStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
