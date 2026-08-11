import 'package:flutter/material.dart';

class GoldenTicketBanner extends StatelessWidget {
  const GoldenTicketBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: GoldenTicketClipper(),
      child: Container(
        width: double.infinity,
        height: 155,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE082), Color(0xFFFFC107), Color(0xFFFFA000)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -55,
              right: -35,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.13),
                ),
              ),
            ),
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
                      children: const [
                        Row(
                          children: [
                            _GoldenTag(),
                            SizedBox(width: 5),
                            Text(
                              'TICKET',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Text(
                          '100% Cashback',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Shop now & get rewarded!',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 115,
                  width: 2,
                  child: CustomPaint(painter: DashedVerticalLinePainter()),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'UP TO',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹500',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8),
                        _ParticipateButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'GOLDEN',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ParticipateButton extends StatelessWidget {
  const _ParticipateButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: const Text(
          'PARTICIPATE',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class GoldenTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    const cornerRadius = 12.0;

    final path = Path();

    // Top edge stays straight and professional.
    path.moveTo(cornerRadius, 0);
    path.lineTo(width - cornerRadius, 0);
    path.quadraticBezierTo(width, 0, width, cornerRadius);

    // Right torn edge: deep, uneven, manually irregular paper tear.
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

    // Bottom edge stays straight.
    path.quadraticBezierTo(width, height, width - cornerRadius, height);
    path.lineTo(cornerRadius, height);
    path.quadraticBezierTo(0, height, 0, height - cornerRadius);

    // Left torn edge: deep irregular paper tears in opposite direction.
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedVerticalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..strokeWidth = 1.2;

    const dashHeight = 5.0;
    const gap = 5.0;
    double y = 0;

    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
