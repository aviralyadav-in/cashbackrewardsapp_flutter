import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/all_categories_screen.dart';
import '../../screens/category_detail_screen.dart';
import '../../theme/app_theme.dart';

/// Category definition model for the Explore Categories section
class _CategoryItem {
  final String id;
  final String title;
  final IconData? icon;
  final bool isCustomTshirt;

  const _CategoryItem({
    required this.id,
    required this.title,
    this.icon,
    this.isCustomTshirt = false,
  });
}

/// TopCategoriesSection renders a compact "EXPLORE CATEGORIES" header
/// and squircle cards styled to match the KashIQ app palette:
/// - Header: 4-square grid icon + "EXPLORE CATEGORIES" + "View All →" in brand brown/caramel
/// - Active Card: Deep chocolate espresso with warm golden caramel border & glow
/// - Inactive Cards: Warm ivory surface with beige icon containers & chocolate icons
/// - Compact proportions (68×82px cards, 82px section height)
class TopCategoriesSection extends StatefulWidget {
  final bool isDark;

  const TopCategoriesSection({
    super.key,
    required this.isDark,
  });

  @override
  State<TopCategoriesSection> createState() => _TopCategoriesSectionState();
}

class _TopCategoriesSectionState extends State<TopCategoriesSection> {
  int _selectedIndex = 0;

  static const List<_CategoryItem> _items = [
    _CategoryItem(
      id: 'fashion',
      title: 'Fashion',
      isCustomTshirt: true,
    ),
    _CategoryItem(
      id: 'electronics',
      title: 'Electronics',
      icon: Icons.laptop_chromebook_rounded,
    ),
    _CategoryItem(
      id: 'travel',
      title: 'Travel',
      icon: Icons.flight_rounded,
    ),
    _CategoryItem(
      id: 'food',
      title: 'Food',
      icon: Icons.restaurant_outlined,
    ),
    _CategoryItem(
      id: 'beauty',
      title: 'Beauty',
      icon: Icons.spa_outlined,
    ),
    _CategoryItem(
      id: 'grocery',
      title: 'Grocery',
      icon: Icons.shopping_bag_outlined,
    ),
    _CategoryItem(
      id: 'credit_cards',
      title: 'Cards',
      icon: Icons.credit_card_outlined,
    ),
  ];

  void _handleItemTap(int index, _CategoryItem item) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CategoryDetailScreen(
          categoryId: item.id,
          categoryTitle: item.title,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.accentBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. COMPACT HEADER ROW: [⊞] EXPLORE CATEGORIES               View All →
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 4-Square Category Grid Icon in brand navy/blue
              _CategoryGridIcon(
                color: primaryAccent,
                size: 15.5,
              ),
              const SizedBox(width: 7),

              // "Explore Categories" Title
              Text(
                'Explore Categories',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),

              const Spacer(),

              // "View All →" Action Button in brand color
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AllCategoriesScreen(),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: primaryAccent,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13.5,
                      color: primaryAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 9),

        // 2. COMPACT HORIZONTAL CATEGORY ITEMS
        SizedBox(
          height: 82,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8.5),
            itemBuilder: (context, index) {
              final item = _items[index];
              final isSelected = index == _selectedIndex;

              return _CategoryCardItem(
                item: item,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => _handleItemTap(index, item),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A 2x2 grid icon representing categories (matching the 4 outlined squares in reference)
class _CategoryGridIcon extends StatelessWidget {
  final Color color;
  final double size;

  const _CategoryGridIcon({
    required this.color,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final boxSize = (size - 2.8) / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSquare(boxSize),
              _buildSquare(boxSize),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSquare(boxSize),
              _buildSquare(boxSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquare(double dim) {
    return Container(
      width: dim,
      height: dim,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.2),
        border: Border.all(color: color, width: 1.4),
      ),
    );
  }
}

/// Custom painter for the exact outlined T-shirt icon seen in the reference image
class _TShirtPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _TShirtPainter({
    required this.color,
    this.strokeWidth = 1.6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Collar top-left
    path.moveTo(w * 0.35, h * 0.16);
    // Collar scoop curve
    path.quadraticBezierTo(w * 0.50, h * 0.30, w * 0.65, h * 0.16);
    // Right shoulder
    path.lineTo(w * 0.88, h * 0.28);
    // Right sleeve bottom
    path.lineTo(w * 0.80, h * 0.46);
    // Right armpit
    path.lineTo(w * 0.70, h * 0.40);
    // Right body side down to bottom hem
    path.lineTo(w * 0.70, h * 0.86);
    // Bottom hem
    path.lineTo(w * 0.30, h * 0.86);
    // Left body side up to armpit
    path.lineTo(w * 0.30, h * 0.40);
    // Left sleeve bottom
    path.lineTo(w * 0.20, h * 0.46);
    // Left shoulder
    path.lineTo(w * 0.12, h * 0.28);
    // Close back to collar top-left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TShirtPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// Individual rounded category card styled to seamlessly match the KashIQ app palette
class _CategoryCardItem extends StatefulWidget {
  final _CategoryItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryCardItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_CategoryCardItem> createState() => _CategoryCardItemState();
}

class _CategoryCardItemState extends State<_CategoryCardItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isSelected = widget.isSelected;
    final isDark = widget.isDark;

    // 1. Selected colors: Crisp Ice Blue pod + Electric Royal Blue icon & accents
    final selectedIconBg = isDark ? const Color(0xFF1E3A8A) : AppColors.iceBlue;
    final selectedIconColor = isDark ? AppColors.darkPrimary : AppColors.accentBlue;

    // 2. Unselected colors: Subtle light container + Navy Medium icon
    final unselectedIconBg = isDark ? AppColors.darkCard : AppColors.surfaceSubtle;
    final unselectedIconColor = isDark ? AppColors.darkTextSecondary : AppColors.navyMedium;

    final iconBg = isSelected ? selectedIconBg : unselectedIconBg;
    final iconColor = isSelected ? selectedIconColor : unselectedIconColor;
    final labelColor = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.accentBlue)
        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Category Icon Container
              Container(
                width: 48,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: isDark ? AppColors.darkPrimary : AppColors.accentBlue,
                          width: 1.5,
                        )
                      : Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                          width: 1.0,
                        ),
                ),
                child: Center(
                  child: _buildIcon(item, iconColor),
                ),
              ),
              const SizedBox(height: 5),

              // Bottom Label
              Text(
                item.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: labelColor,
                  letterSpacing: -0.15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(_CategoryItem item, Color color) {
    if (item.isCustomTshirt) {
      return CustomPaint(
        size: const Size(24, 24),
        painter: _TShirtPainter(color: color, strokeWidth: 1.8),
      );
    }

    if (item.id == 'travel') {
      return Transform.rotate(
        angle: 0.785, // 45 degrees tilt matching reference
        child: Icon(
          Icons.flight_rounded,
          size: 23,
          color: color,
        ),
      );
    }

    return Icon(
      item.icon ?? Icons.category_rounded,
      size: 23,
      color: color,
    );
  }
}
