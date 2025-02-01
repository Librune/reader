import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/provider/menu.dart';

class GestureUsecase {
  final WidgetRef ref;
  GestureUsecase(this.ref);

  callMenu() {
    final menuVisible = ref.read(menuProvider);
    if (menuVisible.none) {
      ref.read(menuProvider.notifier).openTop();
      ref.read(menuProvider.notifier).openBottom();
    } else {
      ref.read(menuProvider.notifier).closeTop();
      ref.read(menuProvider.notifier).closeBottom();
    }
  }
}
