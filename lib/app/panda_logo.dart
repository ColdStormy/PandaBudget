import 'package:flutter/material.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';

/// The app's mark: a panda face on a bamboo-green disc.
class PandaLogo extends StatelessWidget {
  const PandaLogo({this.size = 40, super.key});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: const _PandaPainter());
}

class _PandaPainter extends CustomPainter {
  const _PandaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);
    final black = Paint()..color = PandaColors.ink;
    final white = Paint()..color = PandaColors.white;

    canvas
      ..drawCircle(center, s / 2, Paint()..color = PandaColors.bamboo)
      // Ears.
      ..drawCircle(Offset(s * 0.27, s * 0.28), s * 0.12, black)
      ..drawCircle(Offset(s * 0.73, s * 0.28), s * 0.12, black)
      // Face.
      ..drawOval(
        Rect.fromCenter(
          center: Offset(s / 2, s * 0.55),
          width: s * 0.64,
          height: s * 0.56,
        ),
        white,
      );

    // Eye patches, tilted outwards.
    for (final side in [-1.0, 1.0]) {
      canvas
        ..save()
        ..translate(s / 2 + side * s * 0.14, s * 0.52)
        ..rotate(side * 0.5)
        ..drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: s * 0.13,
            height: s * 0.18,
          ),
          black,
        )
        ..restore()
        ..drawCircle(
          Offset(s / 2 + side * s * 0.135, s * 0.51),
          s * 0.022,
          white,
        );
    }
    // Nose.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(s / 2, s * 0.665),
        width: s * 0.09,
        height: s * 0.06,
      ),
      black,
    );
  }

  @override
  bool shouldRepaint(_PandaPainter oldDelegate) => false;
}
