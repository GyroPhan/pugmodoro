import 'package:flutter/material.dart';

LinearGradient kBackgroundColor = LinearGradient(
    end: Alignment.bottomLeft,
    begin: Alignment.topRight,
    colors: [Color(0xffd1dded), Colors.white]);

LinearGradient kTextPressColor = LinearGradient(
    end: Alignment.bottomLeft,
    begin: Alignment.topRight,
    colors: [
      Color(0xff8A2387),
      Color(0xffE94057),
      Color(0xffF27121),
    ]);

LinearGradient kTextColor = LinearGradient(
    end: Alignment.bottomLeft,
    begin: Alignment.topRight,
    colors: [
      Color(0xff4e54c8),
      Color(0xff8f94fb),
    ]);

final Color baseColor = Color(0xFFF2F2F2);

class GradientText extends StatelessWidget {
  GradientText({
    required this.text,
    required this.gradient,
    this.fontSize = 50,
  });

  final String text;
  final Gradient gradient;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: 'Gum',
        ),
      ),
    );
  }
}
