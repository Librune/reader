import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/usecase/gesture_usecase.dart';

class GestureWrapper extends HookConsumerWidget {
  const GestureWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gestureUsecase = GestureUsecase(ref);
    return GestureDetector(
      // onHorizontalDragStart: (details) {},
      // onHorizontalDragUpdate: (details) {},
      // onTapDown: gestureUsecase.handleTapDown,
      child: Listener(
        onPointerDown: (event) {},
        onPointerMove: (event) {},
        onPointerUp: (event) {},
        child: child,
      ),
    );
  }
}
