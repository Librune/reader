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
  final Map<ReaderBottomSheet, GlobalKey> _sheetKeys = {};
  PersistentBottomSheetController? controller;

  GlobalKey _getKeyForType(ReaderBottomSheet type) {
    return _sheetKeys[type] ??= GlobalKey();
  }

  PersistentBottomSheetController? _show(
    Widget child,
    ReaderBottomSheet type, {
    double? maxHeight,
  }) {
    final key = _getKeyForType(type);
    return sheetCtx.currentState?.showBottomSheet(
      (BuildContext context) {
        return RepaintBoundary(
          key: key,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight ?? MediaQuery.of(context).size.height),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 84),
              child: child,
            ),
          ),
        );
      },
      showDragHandle: true,
      enableDrag: true,
    );
  }

  void _clear(WidgetRef ref) {
    ref.read(menuProvider.notifier).closeSub();
  }

  void close() {
    controller?.close();
  }

  void toggle(
    Widget child, {
    required ReaderBottomSheet type,
    required WidgetRef ref,
    double? maxHeight,
  }) {
    final menu = ref.read(menuProvider);
    final subVisible = menu.sub;
    final _type = menu.subType;
    if (subVisible) {
      if (type == _type) {
        sheetCtx.currentContext?.pop();
        _clear(ref);
        return;
      }
    }
    ref.read(menuProvider.notifier).openSub(type);
    controller = _show(child, type, maxHeight: maxHeight);
    controller?.closed.then((value) {
      _clear(ref);
    });
  }
}
