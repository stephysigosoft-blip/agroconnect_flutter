import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class AdRepostedSuccessScreen extends StatelessWidget {
  const AdRepostedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final VoidCallback onButtonPressed =
        args['onButtonPressed'] ??
        () {
          Get.offAllNamed('/home');
        };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.offAllNamed('/home'),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B834F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSuccessIcon(),
              const SizedBox(height: 24),
              const Text(
                'AD REPOSTED SUCCESSFULLY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 180),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B834F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Preview Ad',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Get.offAllNamed('/home'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: Color(0xFF1B834F), width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF1B834F),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(110, 110),
          painter: ScallopedPainter(color: const Color(0xFF1B834F)),
        ),
        const Icon(Icons.check, color: Colors.white, size: 60),
      ],
    );
  }
}

class ScallopedPainter extends CustomPainter {
  final Color color;

  ScallopedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.88;
    final int scallopCount = 12;

    final Path path = Path();
    final double angleStep = (2 * math.pi) / (scallopCount * 2);

    for (int i = 0; i < scallopCount * 2; i++) {
      final double angle = i * angleStep - (math.pi / 2);
      final double radius = (i % 2 == 0) ? outerRadius : innerRadius;

      if (i == 0) {
        path.moveTo(
          centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle),
        );
      } else {
        final double cpAngle = (i - 0.5) * angleStep - (math.pi / 2);
        final double cpRadius = outerRadius * 1.05;
        final double cpX = centerX + cpRadius * math.cos(cpAngle);
        final double cpY = centerY + cpRadius * math.sin(cpAngle);

        path.quadraticBezierTo(
          cpX,
          cpY,
          centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle),
        );
      }
    }

    final double firstAngle = -(math.pi / 2);
    final double firstX = centerX + outerRadius * math.cos(firstAngle);
    final double firstY = centerY + outerRadius * math.sin(firstAngle);
    final double lastCpAngle =
        (scallopCount * 2 - 0.5) * angleStep - (math.pi / 2);
    final double lastCpRadius = outerRadius * 1.05;
    final double lastCpX = centerX + lastCpRadius * math.cos(lastCpAngle);
    final double lastCpY = centerY + lastCpRadius * math.sin(lastCpAngle);
    path.quadraticBezierTo(lastCpX, lastCpY, firstX, firstY);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
