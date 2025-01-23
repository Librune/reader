import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:ui' as ui;

import 'package:reader/app/architecture/utils/log.dart';

class ShaderBackground extends StatelessWidget {
  const ShaderBackground({
    super.key,
    required this.cover,
    this.blurAmount = 3.0,
    required this.colorScheme,
  });

  final String cover;
  final double blurAmount;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/cover_bg.frag',
      (BuildContext context, FragmentShader? shader, Widget? child) {
        // 1. 处理shader加载失败的情况
        if (shader == null) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text('无法加载着色器'),
            ),
          );
        }

        // 2. 添加尺寸约束
        return LayoutBuilder(
          builder: (context, constraints) {
            // 确保有最小尺寸
            if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
              return const SizedBox.shrink();
            }

            // 3. 使用CustomPaint
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: ShaderPainter(
                shader: shader,
                image: cover,
                blurAmount: blurAmount,
                colorScheme: colorScheme,
              ),
            );
          },
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
  final ColorScheme colorScheme;

  ShaderPainter({required this.shader, required this.image, required this.blurAmount, required this.colorScheme}) {
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
        Log.d('Image loaded: $image');
      },
      onError: (exception, stackTrace) {
        Log.e('Error loading image: $exception');
        completer.completeError(exception);
        imageStream.removeListener(listener!);
      },
    );

    imageStream.addListener(listener);

    try {
      await completer.future;
    } catch (e) {
      Log.e('Failed to load image: $e');
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_image == null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.grey,
      );
      return;
    }

    // 1. 计算真实绘制尺寸
    double targetWidth = size.width;
    double scale = targetWidth / _image!.width;
    double targetHeight = _image!.height * scale;

    final Color overlayColor = Color.alphaBlend(colorScheme.primary.withAlpha(50), Colors.black);

    // 2. 设置着色器参数 - 保持1:1的缩放比
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, targetHeight) // 使用计算出的实际高度
      ..setFloat(2, blurAmount)
      ..setFloat(3, 1.0) // 水平缩放为1
      ..setFloat(4, 1.0) // 垂直缩放为1
      ..setFloat(5, 0.0) // 无水平偏移
      ..setFloat(6, 0.0) // 无垂直偏移
      ..setFloat(7, overlayColor.r)
      ..setFloat(8, overlayColor.g)
      ..setFloat(9, overlayColor.b)
      ..setFloat(10, overlayColor.a)
      ..setImageSampler(0, _image!);

    // 3. 绘制矩形，高度使用实际计算值
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, targetHeight),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.shader != shader ||
        oldDelegate.image != image ||
        oldDelegate.blurAmount != blurAmount ||
        oldDelegate._image != _image || // 添加图片变化的判断
        oldDelegate.colorScheme != colorScheme; // 添加颜色变化的判断
  }
}
