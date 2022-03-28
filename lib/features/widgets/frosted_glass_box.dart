import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlassBox extends StatelessWidget {
  final double? width, height;
  final Widget child;
  final BorderRadius? borderRadius;

  const FrostedGlassBox({
    Key? key,
    this.height,
    required this.child,
    this.borderRadius,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: width ?? size.width,
      height: height ?? size.height,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 7.0,
              sigmaY: 7.0,
            ),
            child: Container(
              width: width ?? size.width,
              height: height ?? size.height,
              child: Text(" "),
            ),
          ),
          Opacity(
              opacity: 0.05,
              child: Image.asset(
                "assets/images/noise.png",
                fit: BoxFit.cover,
                width: width ?? size.width,
                height: height ?? size.height,
              )),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.45),
                  blurRadius: 30,
                  offset: Offset(2, 2),
                ),
              ],
              borderRadius: borderRadius,
              border: Border(
                left: BorderSide(
                  color: Colors.black.withOpacity(0.4),
                  width: 4.0,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.1),
                ],
                stops: [
                  0.0,
                  1.0,
                ],
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
