import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';

class MenuSheetUsecase {
  static final MenuSheetUsecase _instance = MenuSheetUsecase._internal();
  factory MenuSheetUsecase() => _instance;
  MenuSheetUsecase._internal();

  final sheetCtx = GlobalKey<ScaffoldState>();

  PersistentBottomSheetController? controller;

  PersistentBottomSheetController? _show(Widget child) {
    return sheetCtx.currentState?.showBottomSheet(
      (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 84),
          child: child,
        );
      },
      showDragHandle: true,
    );
  }

  void _clear(WidgetRef ref) {
    ref.read(menuProvider.notifier).closeSub();
  }

  void toggle(Widget child, {required ReaderBottomSheet type, required WidgetRef ref}) {
    final menu = ref.read(menuProvider);
    final subVisible = menu.sub;
    final _type = menu.subType;
    if (subVisible) {
      if (type == _type) {
        sheetCtx.currentContext?.pop();
        _clear(ref);
        return;
      } else {
        _clear(ref);
        controller = _show(child);
      }
    } else {
      ref.read(menuProvider.notifier).openSub(type);
      controller = _show(child);
    }
    controller?.closed.then((value) {
      _clear(ref);
    });
  }
}
