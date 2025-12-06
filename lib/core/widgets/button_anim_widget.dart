import 'package:flutter/material.dart';

class AnimatedGradientBorderButton extends StatefulWidget {
  const AnimatedGradientBorderButton({
    super.key,
    required this.onTap,
    required this.child,
    this.height = 50.0,
    this.width = 150.0,
    this.strokeWidth = 2.0,
    this.duration = const Duration(seconds: 3),
    this.gradientColors = const [Colors.purpleAccent, Colors.pinkAccent, Colors.lightBlueAccent],
    this.borderRadius = 12.0,
  });

  final VoidCallback onTap;
  final Widget child;
  final double strokeWidth;
  final double height;
  final double width;
  final Duration duration;
  final List<Color> gradientColors;
  final double borderRadius;

  @override
  State<AnimatedGradientBorderButton> createState() => _AnimatedGradientBorderButtonState();
}

class _AnimatedGradientBorderButtonState extends State<AnimatedGradientBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(); // Membuat animasi berulang terus menerus
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: CustomPaint(
          // Menggunakan painter kustom untuk menggambar border
          painter: _GradientBorderPainter(
            animation: _controller,
            strokeWidth: widget.strokeWidth,
            colors: widget.gradientColors,
            borderRadius: widget.borderRadius,
          ),
          // Child adalah konten di dalam tombol
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.white, // Warna latar belakang tombol
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// Class Painter kustom untuk menggambar border
class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({
    required this.animation,
    required this.strokeWidth,
    required this.colors,
    required this.borderRadius,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final double strokeWidth;
  final List<Color> colors;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // Buat path berbentuk persegi panjang dengan sudut membulat
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      // Buat gradient yang berputar (SweepGradient)
      ..shader = SweepGradient(
        colors: colors,
        startAngle: 0.0,
        endAngle: 6.28, // 2 * pi
        // Gunakan nilai animasi untuk memutar transform gradient
        transform: GradientRotation(animation.value * 2 * 3.14159),
      ).createShader(rrect.outerRect);

    // Gambar path border pada canvas
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}