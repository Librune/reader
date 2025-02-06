import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/ui/components/bottom_sheet.dart';

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

  final GlobalKey<PersistentBottomSheetState> catalogSheetKey = GlobalKey<PersistentBottomSheetState>();
  final GlobalKey<PersistentBottomSheetState> fontSheetKey = GlobalKey<PersistentBottomSheetState>();
  final GlobalKey<PersistentBottomSheetState> themeSheetKey = GlobalKey<PersistentBottomSheetState>();
  final GlobalKey<PersistentBottomSheetState> configSheetKey = GlobalKey<PersistentBottomSheetState>();

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

  Map<GlobalKey<PersistentBottomSheetState>, bool> sheetVisible = {};

  _checkSheet(GlobalKey<PersistentBottomSheetState> checkKey, GlobalKey<PersistentBottomSheetState> targetKey) {
    if (checkKey == targetKey) {
      if (checkKey.currentState?.isVisible ?? false) {
        checkKey.currentState?.hide();
        sheetVisible[checkKey] = false;
      } else {
        checkKey.currentState?.show();
        sheetVisible[checkKey] = true;
      }
    } else {
      checkKey.currentState?.hide();
      sheetVisible[checkKey] = false;
    }
  }

  onSheetDragHide(GlobalKey<PersistentBottomSheetState> key, {required WidgetRef ref}) {
    sheetVisible[key] = false;
    _checkParentBars(ref);
  }

  _checkParentBars(WidgetRef ref) {
    // 检查 sheetVisible 中是否有 true 值
    final hasVisible = sheetVisible.values.any((element) => element);
    if (hasVisible) {
      ref.read(menuProvider.notifier).openSub(ReaderBottomSheet.catalog);
    } else {
      ref.read(menuProvider.notifier).closeSub();
    }
  }

  void toggleSheet(
    GlobalKey<PersistentBottomSheetState> key, {
    required WidgetRef ref,
  }) {
    _checkSheet(catalogSheetKey, key);
    _checkSheet(fontSheetKey, key);
    _checkSheet(themeSheetKey, key);
    _checkSheet(configSheetKey, key);
    _checkParentBars(ref);
  }
}
