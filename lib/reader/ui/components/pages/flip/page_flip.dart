import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/libs/shader_helper.dart';

class PageFlip extends HookConsumerWidget {
  const PageFlip({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragProgress = useState(0.0);
    final startPosition = useState<Offset>(Offset.zero);
    final edgePosition = useState(0.0);
    final initialEdgePosition = useState(0.0);

    final handleDragStart = useCallback((DragStartDetails details) {
      startPosition.value = details.localPosition;
      initialEdgePosition.value = edgePosition.value; // 记录初始边缘位置
    }, []);

    final handleDragUpdate = useCallback((DragUpdateDetails details) {
      final currentX = details.localPosition.dx;
      final startX = startPosition.value.dx;
      final screenWidth = context.size!.width;

      // 计算相对移动距离（考虑双向拖动）
      final delta = currentX - startX;

      // 更新边缘位置（保持与手指移动 1:1 比例）
      edgePosition.value = (initialEdgePosition.value + delta).clamp(0.0, screenWidth);

      // 计算标准化进度（-1 到 1 范围）
      dragProgress.value = (delta / screenWidth).clamp(-1.0, 1.0);
    }, []);

    final handleDragEnd = useCallback((DragEndDetails details) {
      final velocity = details.primaryVelocity ?? 0;
      final screenWidth = context.size!.width;

      // 根据最终进度决定是否完成翻页
      if (velocity.abs() > 500) {
        edgePosition.value = velocity > 0 ? screenWidth : 0.0;
      } else {
        if (dragProgress.value.abs() > 0.3) {
          edgePosition.value = dragProgress.value > 0 ? screenWidth : 0.0;
        } else {
          edgePosition.value = initialEdgePosition.value;
        }
      }

      dragProgress.value = 0.0;
      startPosition.value = Offset.zero;
    }, []);

    return GestureDetector(
      onHorizontalDragStart: handleDragStart,
      onHorizontalDragUpdate: handleDragUpdate,
      onHorizontalDragEnd: handleDragEnd,
      child: RepaintBoundary(
        child: ShaderBuilder(
          (context, shader, _) {
            return AnimatedSampler(
              (image, size, canvas) {
                // 向着色器传递标准化参数
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, edgePosition.value)
                  ..setFloat(3, dragProgress.value) // 使用标准化进度
                  ..setImageSampler(0, image);

                ShaderHelper.drawShaderRect(shader, size, canvas);
              },
              // 保持子组件位置不变
              child: child,
            );
          },
          assetKey: 'shaders/page_flip.frag',
        ),
      ),
    );
  }
}
