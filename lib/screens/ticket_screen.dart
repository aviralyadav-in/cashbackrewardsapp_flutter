import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoldenTicketBanner extends StatefulWidget {
  final VoidCallback? onTap;

  const GoldenTicketBanner({super.key, this.onTap});

  @override
  State<GoldenTicketBanner> createState() => _GoldenTicketBannerState();
}

class _GoldenTicketBannerState extends State<GoldenTicketBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  // Number of vertical slices for smooth continuous wave deformation
  static const int _sliceCount = 28;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bannerHeight = 155.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerWidth = constraints.maxWidth;
        final sliceWidth = bannerWidth / _sliceCount;

        // Base ticket content widget (built once and shared across slices)
        final ticketContent = _TicketVisualContent(
          width: bannerWidth,
          height: bannerHeight,
          onTap: widget.onTap,
          waveController: _waveController,
        );

        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, _) {
              final t = _waveController.value;

              return SizedBox(
                width: bannerWidth,
                height: bannerHeight + 28, // Headroom for increased wave peaks
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Dynamic ambient shadow that deforms with the flag wave
                    Positioned(
                      top: 14,
                      left: 0,
                      right: 0,
                      height: bannerHeight,
                      child: CustomPaint(
                        painter: _FlagShadowPainter(
                          animationProgress: t,
                          sliceCount: _sliceCount,
                        ),
                      ),
                    ),

                    // Vertical Slices forming the progressive waving cloth deformation
                    ...List.generate(_sliceCount, (index) {
                      // Normalized position along the flag from left (0.0) to right (1.0)
                      final u = (index + 0.5) / _sliceCount;

                      // Left edge is completely anchored (amplitude = 0)
                      // Progressive growth: u^1.30 for clear middle wave & max right wave
                      final amplitudeWeight = math.pow(u, 1.30).toDouble();

                      // Wave phase travels smoothly from left to right
                      final phase = (t * 2 * math.pi) - (u * 2.2 * math.pi);

                      // Vertical sinusoidal wave displacement (increased by 40%: 10.5px max)
                      final dy = math.sin(phase) * (10.5 * amplitudeWeight);

                      // Out-of-plane perspective depth (enhanced 3D forward/backward wave depth)
                      final zDepth = math.cos(phase) * (0.052 * amplitudeWeight);
                      final scaleY = 1.0 + zDepth;

                      // Subtle shear angle matching the increased wave slope
                      final shearY = math.cos(phase) * (0.058 * amplitudeWeight);

                      final sliceLeft = index * sliceWidth;
                      // Tiny 0.6px overlap to eliminate any sub-pixel rendering gaps
                      final renderWidth = sliceWidth + 0.6;

                      return Positioned(
                        left: sliceLeft,
                        top: 14 + dy,
                        width: renderWidth,
                        height: bannerHeight,
                        child: Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // 3D perspective
                            ..setEntry(1, 0, shearY) // Vertical shear
                            ..setEntry(1, 1, scaleY), // Vertical scale (forward/backward depth)
                          child: ClipRect(
                            child: OverflowBox(
                              minWidth: bannerWidth,
                              maxWidth: bannerWidth,
                              minHeight: bannerHeight,
                              maxHeight: bannerHeight,
                              alignment: Alignment(
                                // Map slice to its exact window within the full banner
                                bannerWidth > 0
                                    ? -1.0 + (2.0 * sliceLeft / (bannerWidth - renderWidth.clamp(1.0, bannerWidth)))
                                    : -1.0,
                                0.0,
                              ),
                              child: ticketContent,
                            ),
                          ),
                        ),
                      );
                    }),

                    // Fixed Left Flag Spine / Anchor accent (shows it is firmly attached)
                    Positioned(
                      left: 0,
                      top: 14,
                      width: 4,
                      height: bannerHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFDF7D),
                              Color(0xFFB07613),
                              Color(0xFF5E3902),
                              Color(0xFFB07613),
                              Color(0xFFFFDF7D),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 3,
                              offset: const Offset(-1, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// The visual rendering of the Golden Ticket banner content & textures
class _TicketVisualContent extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onTap;
  final AnimationController waveController;

  const _TicketVisualContent({
    required this.width,
    required this.height,
    required this.onTap,
    required this.waveController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipPath(
          clipper: GoldenTicketClipper(),
          child: Stack(
            children: [
              // 1. Multi-Stop Metallic Gold Gradient
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.12, 0.32, 0.52, 0.72, 0.88, 1.0],
                      colors: [
                        Color(0xFFFFF7D6), // Specular light gold
                        Color(0xFFF3D279), // Bright yellow gold
                        Color(0xFFDFAB32), // Warm bullion gold
                        Color(0xFFFFEEAA), // Soft sheen highlight
                        Color(0xFFD19726), // Deep rich gold
                        Color(0xFFB07613), // Bronze gold shadow
                        Color(0xFF875405), // Dark golden edge
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Brushed Metallic Texture & Micro Grain
              Positioned.fill(
                child: CustomPaint(
                  painter: _BrushedGoldTexturePainter(),
                ),
              ),

              // 3. Dynamic Traveling Wave Highlights & Surface Light Ripples
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: waveController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _WaveLightingPainter(
                        animationValue: waveController.value,
                      ),
                    );
                  },
                ),
              ),

              // 4. Luxury Security Watermark Circles
              Positioned(
                top: -65,
                right: -40,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF7A4E0B).withValues(alpha: 0.15),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 5. Engraved Bevel Border Rim
              Positioned.fill(
                child: CustomPaint(
                  painter: _GoldenTicketBorderPainter(),
                ),
              ),

              // 6. Ticket Content Row
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 18,
                        bottom: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const _GoldenTag(),
                              const SizedBox(width: 6),
                              Text(
                                'TICKET',
                                style: TextStyle(
                                  color: const Color(0xFF1E1502),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      offset: const Offset(0.5, 0.8),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '100% Cashback',
                            style: TextStyle(
                              color: const Color(0xFF1A1202),
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                              shadows: [
                                Shadow(
                                    color: Colors.white.withValues(alpha: 0.65),
                                  offset: const Offset(0.5, 1.0),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Shop now & get rewarded!',
                            style: TextStyle(
                              color: const Color(0xFF3D2D0B),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  offset: const Offset(0.5, 0.5),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 115,
                    width: 2,
                    child: CustomPaint(
                      painter: DashedVerticalLinePainter(),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'UP TO',
                            style: TextStyle(
                              color: const Color(0xFF4A370E),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  offset: const Offset(0.5, 0.5),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹500',
                            style: TextStyle(
                              color: const Color(0xFF140D01),
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  offset: const Offset(0.5, 1.0),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _ParticipateButton(
                            onTap: onTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoldenTag extends StatelessWidget {
  const _GoldenTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF181206),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFFFDF7D).withValues(alpha: 0.6),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 3,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: const Text(
        'GOLDEN',
        style: TextStyle(
          color: Color(0xFFFFEFA6),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ParticipateButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ParticipateButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onTap ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF140F05),
            foregroundColor: const Color(0xFFFFEFA6),
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: const Color(0xFFFFD568).withValues(alpha: 0.5),
                width: 0.8,
              ),
            ),
          ),
          child: const Text(
            'PARTICIPATE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dynamic shadow painter under the waving flag
class _FlagShadowPainter extends CustomPainter {
  final double animationProgress;
  final int sliceCount;

  _FlagShadowPainter({
    required this.animationProgress,
    required this.sliceCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Draw wavy bottom edge for shadow
    path.moveTo(0, 0);
    path.lineTo(width, 0);

    for (int i = sliceCount; i >= 0; i--) {
      final u = i / sliceCount;
      final amplitude = math.pow(u, 1.30) * 10.5;
      final phase = (animationProgress * 2 * math.pi) - (u * 2.2 * math.pi);
      final dy = math.sin(phase) * amplitude;
      final x = u * width;
      final y = height + dy + 8;

      if (i == sliceCount) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.24)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

    final glowPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _FlagShadowPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress;
  }
}

/// Texture painter that adds subtle brushed gold grain & micro-highlights
class _BrushedGoldTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Diagonal subtle metallic brush streaks
    const spacing = 7.0;
    final totalLines = ((size.width + size.height) / spacing).ceil();

    for (int i = 0; i < totalLines; i++) {
      final isLight = i % 2 == 0;
      grainPaint.color = isLight
          ? Colors.white.withValues(alpha: 0.04)
          : const Color(0xFF6B4500).withValues(alpha: 0.04);

      final startX = i * spacing - size.height;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height, size.height),
        grainPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dynamic wave lighting painter that creates specular traveling highlights & crest/trough shading
class _WaveLightingPainter extends CustomPainter {
  final double animationValue;

  _WaveLightingPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final waveOffset = animationValue * 2 * math.pi;

    // 1. Traveling Specular Gleam across the metallic surface from left to right
    final shimmerCenter = (math.sin(waveOffset) * 0.5 + 0.5);
    final shimmerX = shimmerCenter * size.width;

    final shimmerGradient = LinearGradient(
      begin: const Alignment(-1.0, -0.4),
      end: const Alignment(1.0, 0.4),
      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      colors: [
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 0.32), // Enhanced crisp specular reflection
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 0.0),
      ],
      transform: _GradientTranslationTransform(
        (shimmerX - (size.width / 2)) / size.width,
      ),
    );

    final shimmerPaint = Paint()
      ..shader = shimmerGradient.createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, shimmerPaint);

    // 2. Wave Folds / Curvature Shading: progressive light/dark fold bands responding to deeper wave
    final foldShader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      colors: [
        Colors.transparent,
        Colors.white.withValues(alpha: 0.09 * (math.sin(waveOffset) * 0.5 + 0.5)),
        const Color(0xFF4A2F00).withValues(alpha: 0.13 * (math.cos(waveOffset) * 0.5 + 0.5)),
        Colors.white.withValues(alpha: 0.11 * (math.sin(waveOffset + math.pi) * 0.5 + 0.5)),
        Colors.transparent,
      ],
    ).createShader(rect);

    final foldPaint = Paint()..shader = foldShader;
    canvas.drawRect(rect, foldPaint);
  }

  @override
  bool shouldRepaint(covariant _WaveLightingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _GradientTranslationTransform extends GradientTransform {
  final double dx;

  const _GradientTranslationTransform(this.dx);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx * bounds.width, 0.0, 0.0);
  }
}

/// Engraved inner golden rim painter
class _GoldenTicketBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top highlight rim
    final topHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(12, 1.5),
      Offset(size.width - 12, 1.5),
      topHighlightPaint,
    );

    // Bottom shadow bevel rim
    final bottomShadowPaint = Paint()
      ..color = const Color(0xFF5E3902).withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(12, size.height - 1.5),
      Offset(size.width - 12, size.height - 1.5),
      bottomShadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoldenTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    const cornerRadius = 12.0;

    final path = Path();

    // Top edge
    path.moveTo(cornerRadius, 0);
    path.lineTo(width - cornerRadius, 0);
    path.quadraticBezierTo(
      width,
      0,
      width,
      cornerRadius,
    );

    // Right torn edge
    path.lineTo(width, 10);
    path.lineTo(width - 7, 25);
    path.lineTo(width, 36);
    path.lineTo(width - 12, 49);
    path.lineTo(width, 63);
    path.lineTo(width - 10, 78);
    path.lineTo(width, 91);
    path.lineTo(width - 5, 105);
    path.lineTo(width, 118);
    path.lineTo(width - 13, 133);
    path.lineTo(width, height - cornerRadius);

    // Bottom edge
    path.quadraticBezierTo(
      width,
      height,
      width - cornerRadius,
      height,
    );
    path.lineTo(cornerRadius, height);
    path.quadraticBezierTo(
      0,
      height,
      0,
      height - cornerRadius,
    );

    // Left torn edge
    path.lineTo(0, 128);
    path.lineTo(9, 112);
    path.lineTo(0, 99);
    path.lineTo(12, 86);
    path.lineTo(0, 72);
    path.lineTo(8, 58);
    path.lineTo(0, 44);
    path.lineTo(7, 31);
    path.lineTo(0, 21);
    path.lineTo(5, 11);
    path.lineTo(0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(
    CustomClipper<Path> oldClipper,
  ) =>
      false;
}

class DashedVerticalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark groove for perforation
    final groovePaint = Paint()
      ..color = const Color(0xFF4A2F00).withValues(alpha: 0.40)
      ..strokeWidth = 1.2;

    // Light embossed edge next to perforation
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.50)
      ..strokeWidth = 1.0;

    const dashHeight = 5.0;
    const gap = 5.0;

    double y = 0;

    while (y < size.height) {
      // Highlight line offset by 0.8px
      canvas.drawLine(
        Offset(0.8, y),
        Offset(0.8, y + dashHeight),
        highlightPaint,
      );

      // Main groove
      canvas.drawLine(
        Offset(0, y),
        Offset(0, y + dashHeight),
        groovePaint,
      );

      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
