import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../widgets/network_image_with_skeleton.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search products or offers',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                _debounce = Timer(const Duration(milliseconds: 400), () {
                  if (mounted) {
                    context.read<SearchProvider>().search(value);
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  switch (provider.status) {
                    case SearchStatus.loading:
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF1E90FF)),
                            SizedBox(height: 12),
                            Text('Searching...'),
                          ],
                        ),
                      );
                    case SearchStatus.error:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Color(0xFF1E90FF),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                provider.errorMessage,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.search(provider.query),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    case SearchStatus.loaded:
                      if (provider.searchResults.isEmpty) {
                        return const Center(
                          child: Text('No matching products found.'),
                        );
                      }

                      return ListView.separated(
                        itemCount: provider.searchResults.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final product = provider.searchResults[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                     ClipRRect(
                                       borderRadius: BorderRadius.circular(
                                         12,
                                       ),
                                       child: NetworkImageWithSkeleton(
                                         imageUrl: product.thumbnail,
                                         width: 100,
                                         height: 100,
                                         fit: BoxFit.cover,
                                         borderRadius: BorderRadius.circular(12),
                                         errorBuilder:
                                             (context, error, stackTrace) {
                                               return Container(
                                                 width: 100,
                                                 height: 100,
                                                 color: Theme.of(context).brightness == Brightness.dark
                                                     ? const Color(0xFF242426)
                                                     : Colors.grey.shade200,
                                                 child: const Icon(
                                                   Icons.broken_image,
                                                   size: 40,
                                                   color: Colors.grey,
                                                 ),
                                               );
                                             },
                                       ),
                                     ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            product.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[700],
                                                ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${product.price}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors.green.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12,
                                                      ),
                                                ),
                                                child: Text(
                                                  '-${product.discountPercentage.toStringAsFixed(0)}%',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .green
                                                        .shade800,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ),
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
                        },
                      );
                    case SearchStatus.initial:
                      return const Center(
                        child: Text('Search products by name or keyword.'),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
