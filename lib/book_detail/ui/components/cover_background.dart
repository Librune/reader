import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

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
    // 使用 CachedNetworkImageProvider
    final imageProvider = CachedNetworkImageProvider(image);
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
        print('Error loading image: $exception');
        completer.completeError(exception);
        imageStream.removeListener(listener!);
      },
    );

    imageStream.addListener(listener);
    try {
      await completer.future;
    } catch (e) {
      print('Failed to load image: $e');
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_image == null) {
      // 如果图片未加载，绘制占位颜色
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.grey,
      );
      return;
    }

    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, blurAmount)
      ..setImageSampler(0, _image!);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.shader != shader ||
        oldDelegate.image != image ||
        oldDelegate.blurAmount != blurAmount ||
        oldDelegate._image != _image; // 添加图片变化的判断
  }
}
