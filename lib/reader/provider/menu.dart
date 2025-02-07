import 'package:reader/reader/data/model/menu.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu.g.dart';

@riverpod
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

  closeParent() {
    state = state.copyWith(top: false, bottom: false);
  }

  openBottom() {
    state = state.copyWith(bottom: true);
  }

  closeBottom() {
    state = state.copyWith(bottom: false);
  }

  openParent() {
    state = state.copyWith(top: true, bottom: true);
  }

  openSub(ReaderBottomSheet type) {
    state = state.copyWith(sub: true, subType: type, top: false);
  }

  closeSub() {
    state = state.copyWith(sub: false, subType: null);
  }
}
