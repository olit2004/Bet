import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final state = GoRouterState.of(context);
        if (state.uri.path == '/') {
          // If already on landing page, scroll to top
          final scrollController = PrimaryScrollController.of(context);
          if (scrollController.hasClients) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuart,
            );
          }
        } else {
          context.go('/');
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The icon container based on the screenshot
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _LogoIconPainter(color: AppColors.primaryBlue),
            ),
          ),
          SizedBox(width: size * 0.3),
          // The text part from the screenshot
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beth', // Using "Beth" to match the image accurately
                style: GoogleFonts.manrope(
                  color: AppColors.primaryText,
                  fontSize: size * 0.9,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'RENTAL & BIDDING',
                style: GoogleFonts.inter(
                  color: AppColors.primaryLightBlue,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
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

class _LogoIconPainter extends CustomPainter {
  final Color color;
  _LogoIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Start at left eaves
    path.moveTo(size.width * 0.05, size.height * 0.45);
    // Draw roof peak
    path.lineTo(size.width * 0.5, size.height * 0.05);
    // Draw down to the right eaves
    path.lineTo(size.width * 0.95, size.height * 0.45);
    // Draw down right wall
    path.lineTo(size.width * 0.95, size.height * 0.95);
    // Draw leftwards along the bottom
    path.lineTo(size.width * 0.25, size.height * 0.95);

    canvas.drawPath(path, paint);

    // Draw the dot inside
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.6),
      size.width * 0.15,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
