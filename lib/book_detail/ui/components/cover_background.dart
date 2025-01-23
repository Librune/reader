import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderBackground extends StatelessWidget {
  const ShaderBackground({
    super.key,
    required this.cover,
    this.blurAmount = 3.0,
  });

  final String cover;
  final double blurAmount;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/cover_bg.frag',
      (context, shader, child) {
        return CustomPaint(
          painter: ShaderPainter(
            shader: shader,
            image: cover,
            blurAmount: blurAmount,
          ),
        );
      },
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final String image;
  final double blurAmount;

  ShaderPainter({
    required this.shader,
    required this.image,
    required this.blurAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, blurAmount);

    // 绘制着色器
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.shader != shader || oldDelegate.image != image || oldDelegate.blurAmount != blurAmount;
  }
}
