import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';

class PageFlip extends HookConsumerWidget {
  const PageFlip({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.controller,
  });

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final PageController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Log.e(itemCount);
    final pageController = controller ?? usePageController();
    final currentPage = useState(0);
    final dragProgress = useState(0.0);
    final edgePosition = useState(0.0);
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));

    // 处理边界情况
    final canSwipeLeft = useMemoized(() => currentPage.value > 0);
    final canSwipeRight = useMemoized(() => currentPage.value < itemCount - 1);

    // 动画处理
    void animateToPage(int page) {
      animationController.reset();
      final animation = CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      );
      final start = edgePosition.value;
      final end = page > currentPage.value ? context.size!.width : 0.0;

      animationController.addListener(() {
        final value = animation.value;
        edgePosition.value = start + (end - start) * value;
        dragProgress.value = (end - start) * value / context.size!.width;
      });

      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          currentPage.value = page;
          dragProgress.value = 0.0;
          edgePosition.value = 0.0;
        }
      });

      animationController.forward();
    }

    // 手势处理
    final handleDragStart = useCallback((DragStartDetails details) {
      animationController.stop();
      edgePosition.value = 0.0;
    }, []);

    final handleDragUpdate = useCallback((DragUpdateDetails details) {
      if ((details.primaryDelta ?? 0) > 0 && !canSwipeLeft) return;
      if ((details.primaryDelta ?? 0) < 0 && !canSwipeRight) return;

      final delta = details.primaryDelta ?? 0;
      final screenWidth = context.size!.width;
      final progress = delta / screenWidth;

      dragProgress.value = progress.clamp(-1.0, 1.0);
      edgePosition.value = (edgePosition.value + delta).clamp(0.0, screenWidth);
    }, [canSwipeLeft, canSwipeRight]);

    final handleDragEnd = useCallback((DragEndDetails details) {
      final velocity = details.primaryVelocity ?? 0;
      final screenWidth = context.size!.width;
      final threshold = 24;

      if (velocity.abs() > 500) {
        final direction = velocity > 0 ? -1 : 1;
        final targetPage = currentPage.value + direction;
        if (targetPage >= 0 && targetPage < itemCount) {
          animateToPage(targetPage);
        }
      } else if (edgePosition.value.abs() > threshold) {
        final direction = edgePosition.value > screenWidth / 2 ? 1 : -1;
        final targetPage = currentPage.value + direction;
        if (targetPage >= 0 && targetPage < itemCount) {
          animateToPage(targetPage);
        }
      } else {
        animateToPage(currentPage.value);
      }
    }, [currentPage.value, itemCount]);

    // 动态构建页面内容
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragStart: handleDragStart,
          onHorizontalDragUpdate: handleDragUpdate,
          onHorizontalDragEnd: handleDragEnd,
          child: RepaintBoundary(
              child: Stack(
            children: [
              ShaderBuilder(
                (context, shader, _) {
                  return AnimatedSampler(
                    (image, size, canvas) {
                      shader
                        ..setFloat(0, size.width) // resolution
                        ..setFloat(1, size.height) // resolution
                        ..setFloat(2, edgePosition.value)
                        ..setFloat(3, dragProgress.value)
                        ..setImageSampler(0, image);

                      // ShaderHelper.drawShaderRect(shader, size, canvas);
                      // 绘制双页面内容
                      canvas.save();
                      canvas.drawRect(
                        Rect.fromLTWH(0, 0, size.width, size.height),
                        Paint()..shader = shader,
                      );
                      canvas.restore();
                    },
                    child: itemBuilder(context, currentPage.value),
                  );
                },
                assetKey: 'shaders/page_flip.frag',
              ),
              ShaderBuilder(
                (context, shader, _) {
                  return AnimatedSampler(
                    (image, size, canvas) {
                      shader
                        ..setFloat(0, size.width) // resolution
                        ..setFloat(1, size.height) // resolution
                        ..setFloat(2, edgePosition.value)
                        ..setFloat(3, dragProgress.value)
                        ..setImageSampler(0, image);

                      // ShaderHelper.drawShaderRect(shader, size, canvas);
                      // 绘制双页面内容
                      canvas.save();
                      canvas.drawRect(
                        Rect.fromLTWH(0, 0, size.width, size.height),
                        Paint()..shader = shader,
                      );
                      canvas.restore();
                    },
                    child: itemBuilder(context, currentPage.value + 1),
                  );
                },
                assetKey: 'shaders/page_flip.frag',
              ),
            ],
          )

              //  ShaderBuilder(
              //   (context, shader, _) {
              //     return AnimatedSampler(
              //       (image, size, canvas) {
              //         shader
              //           ..setFloat(0, size.width)
              //           ..setFloat(1, size.height)
              //           ..setFloat(2, edgePosition.value)
              //           ..setFloat(3, dragProgress.value)
              //           ..setImageSampler(0, image);

              //         // 绘制双页面内容
              //         canvas.save();
              //         canvas.drawRect(
              //           Rect.fromLTWH(0, 0, size.width, size.height),
              //           Paint()..shader = shader,
              //         );
              //         canvas.restore();
              //       },
              //       child: Stack(
              //         children: [
              //           Positioned.fill(
              //             child: itemBuilder(context, currentPage.value),
              //           ),
              //           if (dragProgress.value < 0 && canSwipeRight)
              //             Positioned.fill(
              //               child: Transform.translate(
              //                 offset: Offset(constraints.maxWidth, 0),
              //                 child: itemBuilder(context, currentPage.value + 1),
              //               ),
              //             ),
              //           if (dragProgress.value > 0 && canSwipeLeft)
              //             Positioned.fill(
              //               child: Transform.translate(
              //                 offset: Offset(-constraints.maxWidth, 0),
              //                 child: itemBuilder(context, currentPage.value - 1),
              //               ),
              //             ),
              //         ],
              //       ),
              //     );
              //   },
              //   assetKey: 'shaders/page_flip.frag',
              // ),

              ),
        );
      },
    );
  }
}
