import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ButtonGradientWidget extends StatefulWidget {
  ButtonGradientWidget({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    this.fontColor = Colors.black,
  });

  final double height;
  final double width;
  final String text;
  final VoidCallback onTap;
  List<Color> backgroundColor;
  final Color fontColor;

  @override
  State<ButtonGradientWidget> createState() => _ButtonGradientWidgetState();
}

class _ButtonGradientWidgetState extends State<ButtonGradientWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 5.dm;
    double fontSize = 16.sp;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: widget.height,
          width: MediaQuery.of(context).size.width * widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // color: widget.backgroundColor,
            gradient: LinearGradient(
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: widget.backgroundColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),                 
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: widget.fontColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
