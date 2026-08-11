import 'product.dart';
import 'review.dart';

class ProductDetail {
  final int id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final String sku;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String availabilityStatus;
  final int weight;
  final String dimensions;
  final int minimumOrderQuantity;
  final String warrantyInformation;
  final String shippingInformation;
  final String returnPolicy;
  final List<String> tags;
  final List<String> images;
  final String thumbnail;
  final List<Review> reviews;

  ProductDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.brand,
    required this.sku,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.availabilityStatus,
    required this.weight,
    required this.dimensions,
    required this.minimumOrderQuantity,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.returnPolicy,
    required this.tags,
    required this.images,
    required this.thumbnail,
    required this.reviews,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final dimensionsJson = json['dimensions'] as Map<String, dynamic>?;

    final width = dimensionsJson?['width']?.toString() ?? '';
    final height = dimensionsJson?['height']?.toString() ?? '';
    final depth = dimensionsJson?['depth']?.toString() ?? '';
    final dimensions = [
      width,
      height,
      depth,
    ].where((value) => value.isNotEmpty).join(' × ');

    final imagesJson = json['images'] as List<dynamic>?;
    final tagsJson = json['tags'] as List<dynamic>?;
    final reviewsJson = json['reviews'] as List<dynamic>?;

    return ProductDetail(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      brand: (json['brand'] as String?) ?? '',
      sku: (json['sku'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as int?) ?? 0,
      availabilityStatus: (json['availabilityStatus'] as String?) ?? 'Unknown',
      weight: (json['weight'] as int?) ?? 0,
      dimensions: dimensions.isEmpty ? 'Unknown' : dimensions,
      minimumOrderQuantity: (json['minimumOrderQuantity'] as int?) ?? 1,
      warrantyInformation:
          (json['warrantyInformation'] as String?) ?? 'Not available',
      shippingInformation:
          (json['shippingInformation'] as String?) ?? 'Not available',
      returnPolicy: (json['returnPolicy'] as String?) ?? 'Not available',
      tags: tagsJson?.whereType<String>().toList() ?? [],
      images: imagesJson?.whereType<String>().toList() ?? [],
      thumbnail: (json['thumbnail'] as String?) ?? '',
      reviews:
          reviewsJson
              ?.whereType<Map<String, dynamic>>()
              .map((item) => Review.fromJson(item))
              .toList() ??
          [],
    );
  }

  Product toProduct() {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      discountPercentage: discountPercentage,
      thumbnail: thumbnail,
    );
  }
}
