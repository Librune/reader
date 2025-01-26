// page_flip.dart
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
    final dragPosition = useState<Offset>(Offset.zero);
    final startPosition = useState<Offset>(Offset.zero);

    final handleDragStart = useCallback((DragStartDetails details) {
      startPosition.value = details.localPosition;
      dragPosition.value = details.localPosition;
    }, []);

    final handleDragUpdate = useCallback((DragUpdateDetails details) {
      dragPosition.value = details.localPosition;
      final delta = details.primaryDelta ?? 0;
      dragProgress.value = (dragProgress.value - delta / context.size!.width).clamp(-1, 1);
    }, []);

    final handleDragEnd = useCallback((DragEndDetails details) {
      final velocity = details.primaryVelocity ?? 0;
      if (velocity.abs() > 500) {
        dragProgress.value = velocity > 0 ? 1.0 : -1.0;
      } else {
        dragProgress.value = dragProgress.value.abs() > 0.3 ? dragProgress.value.sign * 1.0 : 0.0;
      }
      // 重置拖动位置
      dragPosition.value = Offset.zero;
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
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, dragPosition.value.dx)
                  ..setFloat(3, dragPosition.value.dy)
                  ..setFloat(4, startPosition.value.dx)
                  ..setFloat(5, startPosition.value.dy)
                  ..setImageSampler(0, image);

                ShaderHelper.drawShaderRect(shader, size, canvas);
              },
              child: Stack(
                children: [Positioned.fill(child: child), Positioned.fill(child: child)],
              ),
            );
          },
          assetKey: 'shaders/page_flip.frag',
        ),
      ),
    );
  }
}
