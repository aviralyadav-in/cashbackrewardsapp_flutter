import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  bool _useFallbackFavicon = false;

  static const Map<String, String> _networkHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
  };

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant NetworkImageWithSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _useFallbackFavicon = false;
      });
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  String _sanitizeUrl(String rawUrl) {
    String url = rawUrl.trim();
    if (url.isEmpty) return '';

    if (url.startsWith('//')) {
      url = 'https:$url';
    } else if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  bool _isWebpageUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAuthority) return false;

    final path = uri.path.toLowerCase();
    final hasImageExt = path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp') ||
        path.endsWith('.gif') ||
        path.endsWith('.svg') ||
        path.endsWith('.ico') ||
        path.endsWith('.bmp') ||
        path.endsWith('.avif');

    if (hasImageExt) return false;

    final hasImageQuery = uri.query.toLowerCase().contains('format=') ||
        uri.query.toLowerCase().contains('w=') ||
        uri.query.toLowerCase().contains('fit=') ||
        uri.query.toLowerCase().contains('image');

    if (hasImageQuery) return false;

    // If path is root or HTML/ASP page or standard web path, consider it a webpage URL
    return path.isEmpty ||
        path == '/' ||
        path.endsWith('.html') ||
        path.endsWith('.htm') ||
        path.endsWith('.php') ||
        !path.contains('.');
  }

  String _getFaviconUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.host.isNotEmpty) {
      return 'https://www.google.com/s2/favicons?domain=${uri.host}&sz=128';
    }
    return url;
  }

  bool _isSvgUrl(String url) {
    final clean = url.toLowerCase();
    return clean.endsWith('.svg') || clean.contains('.svg?') || clean.contains('.svg#');
  }

  @override
  Widget build(BuildContext context) {
    final raw = widget.imageUrl.trim();
    if (raw.startsWith('assets/')) {
      if (_isSvgUrl(raw)) {
        return SvgPicture.asset(
          raw,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      }
      return Image.asset(
        raw,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    final sanitized = _sanitizeUrl(widget.imageUrl);

    if (sanitized.isEmpty) {
      return _buildErrorWidget(context, 'Empty URL', null);
    }

    String activeUrl = sanitized;

    if (_useFallbackFavicon || _isWebpageUrl(sanitized)) {
      activeUrl = _getFaviconUrl(sanitized);
    }

    if (_isSvgUrl(activeUrl)) {
      return SvgPicture.network(
        activeUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        headers: _networkHeaders,
        placeholderBuilder: (context) => _ShimmerSkeletonBox(
          controller: _shimmerController,
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          shape: widget.shape,
        ),
        errorBuilder: (context, error, stackTrace) {
          if (!_useFallbackFavicon && !_isWebpageUrl(sanitized)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _useFallbackFavicon = true;
                });
              }
            });
            return _ShimmerSkeletonBox(
              controller: _shimmerController,
              width: widget.width,
              height: widget.height,
              borderRadius: widget.borderRadius,
              shape: widget.shape,
            );
          }
          return widget.errorBuilder != null
              ? widget.errorBuilder!(context, error, stackTrace)
              : _buildErrorWidget(context, error, stackTrace);
        },
      );
    }

    return Image.network(
      activeUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      headers: _networkHeaders,
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
      errorBuilder: (context, error, stackTrace) {
        if (!_useFallbackFavicon && !_isWebpageUrl(sanitized)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _useFallbackFavicon = true;
              });
            }
          });
          return _ShimmerSkeletonBox(
            controller: _shimmerController,
            width: widget.width,
            height: widget.height,
            borderRadius: widget.borderRadius,
            shape: widget.shape,
          );
        }
        return widget.errorBuilder != null
            ? widget.errorBuilder!(context, error, stackTrace)
            : _buildErrorWidget(context, error, stackTrace);
      },
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
