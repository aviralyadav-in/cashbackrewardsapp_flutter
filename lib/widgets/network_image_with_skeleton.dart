import 'package:flutter/material.dart';

class NetworkImageWithSkeleton extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const NetworkImageWithSkeleton({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.errorBuilder,
  });

  @override
  State<NetworkImageWithSkeleton> createState() => _NetworkImageWithSkeletonState();
}

class _NetworkImageWithSkeletonState extends State<NetworkImageWithSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.trim().isEmpty) {
      return _buildErrorWidget(context, 'Empty URL', null);
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _ShimmerSkeletonBox(
          controller: _shimmerController,
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          shape: widget.shape,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _ShimmerSkeletonBox(
          controller: _shimmerController,
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          shape: widget.shape,
        );
      },
      errorBuilder: widget.errorBuilder ??
          (context, error, stackTrace) => _buildErrorWidget(context, error, stackTrace),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stackTrace) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242426) : const Color(0xFFF0F2F5),
        borderRadius: widget.shape == BoxShape.rectangle ? widget.borderRadius : null,
        shape: widget.shape,
      ),
      child: Icon(
        Icons.broken_image_outlined,
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        size: (widget.height != null && widget.height! < 50) ? 20 : 36,
      ),
    );
  }
}

class _ShimmerSkeletonBox extends StatelessWidget {
  final AnimationController controller;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  const _ShimmerSkeletonBox({
    required this.controller,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF222225) : const Color(0xFFE5E5EA);
    final highlightColor = isDark ? const Color(0xFF38383C) : const Color(0xFFF4F4F8);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + (value * 3.0), -0.3),
              end: Alignment(0.5 + (value * 3.0), 0.3),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
