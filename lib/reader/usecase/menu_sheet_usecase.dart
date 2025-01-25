import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/provider/menu.dart';

class MenuSheetUsecase {
  static final MenuSheetUsecase _instance = MenuSheetUsecase._internal();
  factory MenuSheetUsecase() => _instance;
  MenuSheetUsecase._internal();

  final sheetCtx = GlobalKey<ScaffoldState>();

  String _id = "";

  PersistentBottomSheetController? controller;

  PersistentBottomSheetController? _show(Widget child) {
    return sheetCtx.currentState?.showBottomSheet(
      (BuildContext context) {
        return child;
      },
      showDragHandle: true,
    );
  }

  void _clear(WidgetRef ref) {
    ref.read(menuProvider.notifier).closeSub();
    _id = "";
  }

  void toggle(Widget child, {required String id, required WidgetRef ref}) {
    final subVisible = ref.read(menuProvider.select((value) => value.sub));
    if (subVisible) {
      if (id == _id) {
        sheetCtx.currentContext?.pop();
        _clear(ref);
        return;
      } else {
        _clear(ref);
        _id = id;
        controller = _show(child);
      }
    } else {
      _id = id;
      ref.read(menuProvider.notifier).openSub();
      controller = _show(child);
    }
    controller?.closed.then((value) {
      _clear(ref);
    });
  }
}
