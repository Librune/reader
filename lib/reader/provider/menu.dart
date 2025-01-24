import 'package:reader/reader/data/model/menu.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu.g.dart';

@Riverpod(keepAlive: true)
class Menu extends _$Menu {
  @override
  MenuModel build() {
    return MenuModel();
  }

  openTop() {
    state = state.copyWith(top: true);
  }

  closeTop() {
    state = state.copyWith(top: false);
  }

  openBottom() {
    state = state.copyWith(bottom: true);
  }

  closeBottom() {
    state = state.copyWith(bottom: false);
  }

  openSub() {
    state = state.copyWith(sub: true);
  }

  closeSub() {
    state = state.copyWith(sub: false);
  }
}
