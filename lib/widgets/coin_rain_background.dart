import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Single falling note data
// ─────────────────────────────────────────────
class _NoteParticle {
  final double x;        // 0.0–1.0 horizontal start fraction
  final double phase;    // loop phase offset
  final double speed;    // fall speed multiplier
  final double width;    // note width px
  final double height;   // note height px
  final double swing;    // horizontal sway amplitude px
  final double opacity;  // max opacity
  final double rotSpeed; // rotation speed multiplier
  final int    denomination; // 10 / 20 / 50 / 100 / 200 / 500

  const _NoteParticle({
    required this.x,
    required this.phase,
    required this.speed,
    required this.width,
    required this.height,
    required this.swing,
    required this.opacity,
    required this.rotSpeed,
    required this.denomination,
  });
}

// ─────────────────────────────────────────────
// CustomPainter
// ─────────────────────────────────────────────
class _MoneyRainPainter extends CustomPainter {
  final double progress;
  final List<_NoteParticle> particles;
  final bool isDark;

  _MoneyRainPainter({
    required this.progress,
    required this.particles,
    required this.isDark,
  });

  // Indian rupee note colour palette per denomination
  static const _noteColors = {
    10:  Color(0xFF2E7D32), // dark green
    20:  Color(0xFFE65100), // deep orange
    50:  Color(0xFF6A1B9A), // purple
    100: Color(0xFF1565C0), // blue
    200: Color(0xFFAD8B2D), // gold/yellow
    500: Color(0xFF2E7D32), // dark green (500 note is also greenish)
  };

  static const _denominations = [10, 20, 50, 100, 200, 500];

  @override
  void paint(Canvas canvas, Size size) {
    for (final note in particles) {
      final t = ((progress * note.speed + note.phase) % 1.0);

      // Vertical fall
      final y = -note.height + (size.height + note.height * 2) * t;

      // Horizontal sway
      final x = note.x * size.width + sin(t * pi * 3.5 + note.phase * pi) * note.swing;

      // Opacity fade in/out at edges
      double alpha = note.opacity;
      if (t < 0.08) alpha *= (t / 0.08);
      if (t > 0.88) alpha *= (1.0 - (t - 0.88) / 0.12);

      // Rotation angle — oscillates like a leaf falling
      final angle = sin(t * pi * 4 * note.rotSpeed + note.phase * pi * 2) * 0.45;

      final noteColor =
          _noteColors[note.denomination] ?? const Color(0xFF2E7D32);
      final lightColor = Color.lerp(noteColor, Colors.white, 0.35)!;
      final darkColor  = Color.lerp(noteColor, Colors.black, 0.25)!;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width:  note.width,
        height: note.height,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

      // ── Note body gradient ──
      final bodyPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [lightColor.withValues(alpha: alpha), noteColor.withValues(alpha: alpha), darkColor.withValues(alpha: alpha)],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rrect, bodyPaint);

      // ── Border ──
      final borderPaint = Paint()
        ..color = lightColor.withValues(alpha: alpha * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(rrect, borderPaint);

      // ── Inner border line (like real notes) ──
      final innerRect = rect.deflate(3.5);
      final innerRRect = RRect.fromRectAndRadius(innerRect, const Radius.circular(2));
      final innerBorder = Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.7;
      canvas.drawRRect(innerRRect, innerBorder);

      // ── ₹ denomination text ──
      final denomStr = '₹${note.denomination}';
      final tp = TextPainter(
        text: TextSpan(
          text: denomStr,
          style: TextStyle(
            fontSize: note.height * 0.38,
            fontWeight: FontWeight.w900,
            color: Colors.white.withValues(alpha: alpha * 0.92),
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: note.width - 8);

      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

      // ── Small "INDIA" watermark text ──
      final watermarkTp = TextPainter(
        text: TextSpan(
          text: 'INDIA',
          style: TextStyle(
            fontSize: note.height * 0.14,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: alpha * 0.3),
            letterSpacing: 1.2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      watermarkTp.paint(
        canvas,
        Offset(-watermarkTp.width / 2, note.height * 0.22),
      );

      // ── Shine strip (foil-like) ──
      final shinePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: alpha * 0.22),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect);
      canvas.drawRRect(rrect, shinePaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_MoneyRainPainter old) =>
      old.progress != progress || old.isDark != isDark;
}

// ─────────────────────────────────────────────
// Public widget
// ─────────────────────────────────────────────
class CoinRainBackground extends StatefulWidget {
  final int    particleCount;
  final int    seed;
  final Widget? child;

  const CoinRainBackground({
    super.key,
    this.particleCount = 30,
    this.seed = 42,
    this.child,
  });

  @override
  State<CoinRainBackground> createState() => _CoinRainBackgroundState();
}

class _CoinRainBackgroundState extends State<CoinRainBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_NoteParticle>  _particles;

  static const _denominations = [10, 20, 50, 100, 200, 500];

  @override
  void initState() {
    super.initState();

    final rng = Random(widget.seed);
    _particles = List.generate(widget.particleCount, (_) {
      final denom = _denominations[rng.nextInt(_denominations.length)];
      final w = 58.0 + rng.nextDouble() * 28.0;  // 58–86 px wide
      return _NoteParticle(
        x:           rng.nextDouble(),
        phase:       rng.nextDouble(),
        speed:       0.38 + rng.nextDouble() * 0.5,
        width:       w,
        height:      w * 0.46,                      // ~2.17:1 aspect (like real notes)
        swing:       8.0 + rng.nextDouble() * 18.0,
        opacity:     0.55 + rng.nextDouble() * 0.40,
        rotSpeed:    0.6 + rng.nextDouble() * 0.8,
        denomination: denom,
      );
    });

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => CustomPaint(
        painter: _MoneyRainPainter(
          progress:  _ctrl.value,
          particles: _particles,
          isDark:    isDark,
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}
