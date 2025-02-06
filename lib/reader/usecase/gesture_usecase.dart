import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class GestureUsecase {
  final WidgetRef ref;
  GestureUsecase(this.ref);

  toggleMenu() {
    final menuVisible = ref.read(menuProvider);
    if (!ref.read(ProviderUsecase().catalog).hasValue) {
      return;
    }
    if (menuVisible.none) {
      ref.read(menuProvider.notifier).openTop();
      ref.read(menuProvider.notifier).openBottom();
    } else {
      ref.read(menuProvider.notifier).closeTop();
      ref.read(menuProvider.notifier).closeBottom();
    }
  }
}
