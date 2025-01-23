import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
// import xxx as ui
import 'dart:ui' as ui;

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
  ui.Image? _image;

  ShaderPainter({
    required this.shader,
    required this.image,
    required this.blurAmount,
  }) {
    _loadImage();
  }

  Future<void> _loadImage() async {
    // 加载图片
    final imageProvider = NetworkImage(image);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    final completer = Completer<void>();

    ImageStreamListener? listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        _image = info.image;
        completer.complete();
        imageStream.removeListener(listener!);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception);
        imageStream.removeListener(listener!);
      },
    );
    imageStream.addListener(listener);
    await completer.future;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_image == null) return;

    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, blurAmount)
      ..setImageSampler(0, _image!); // 设置图像采样器

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.shader != shader || oldDelegate.image != image || oldDelegate.blurAmount != blurAmount;
  }
}
