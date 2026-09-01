import 'package:flutter/material.dart';

class TopCategoryItemData {
  final String id;
  final String title;
  final String imageUrl;
  final IconData icon;
  final String slug;
  final Color backgroundColor;
  final Color darkBackgroundColor;
  final Color accentColor;

  const TopCategoryItemData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.icon,
    required this.slug,
    this.backgroundColor = const Color(0xFFFFF8F0),
    this.darkBackgroundColor = const Color(0xFF251B15),
    this.accentColor = const Color(0xFFC65D45),
  });
}
