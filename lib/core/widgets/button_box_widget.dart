import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ButtonBoxWidget extends StatefulWidget {
  const ButtonBoxWidget({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.fontColor = Colors.black,
    this.fontSize = 16,
  });

  final double height;
  final double width;
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color fontColor;
  final double fontSize;

  @override
  State<ButtonBoxWidget> createState() => _ButtonBoxWidgetState();
}

class _ButtonBoxWidgetState extends State<ButtonBoxWidget>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 5.dm;

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
            color: widget.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: widget.fontColor,
                fontSize: widget.fontSize,
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/**
 * 
 * Versi Border
 */

class ButtonBoxBorderWidget extends StatefulWidget {
  const ButtonBoxBorderWidget(
   {
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
    required this.text,
    this.borderColor = Colors.white,
    this.fontColor = Colors.white,
    this.isShadow = true,
  });

  final double height;
  final double width;
  final String text;
  final VoidCallback onTap;
  final Color borderColor;
  final Color fontColor;
  final bool isShadow;

  @override
  State<ButtonBoxBorderWidget> createState() => _ButtonBoxBorderWidgetState();
}

class _ButtonBoxBorderWidgetState extends State<ButtonBoxBorderWidget>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
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
            color: Colors.transparent,
            border: Border.all(
              color: widget.borderColor,
              width: 2,
            ),
            boxShadow: (widget.isShadow)? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : null,
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
