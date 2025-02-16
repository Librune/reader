import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/ui/components/bottom_sheet.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class MenuSheetUsecase {
  static final MenuSheetUsecase _instance = MenuSheetUsecase._internal();
  factory MenuSheetUsecase() => _instance;
  MenuSheetUsecase._internal();

  final GlobalKey<PersistentBottomSheetState> catalogSheetKey =
      GlobalKey<PersistentBottomSheetState>();
  final GlobalKey<PersistentBottomSheetState> fontSheetKey =
      GlobalKey<PersistentBottomSheetState>();
  final GlobalKey<PersistentBottomSheetState> themeSheetKey =
      GlobalKey<PersistentBottomSheetState>();
  final GlobalKey<PersistentBottomSheetState> configSheetKey =
      GlobalKey<PersistentBottomSheetState>();

  ReaderBottomSheet? currentSheetType;

  onSheetDragHide(GlobalKey<PersistentBottomSheetState> key,
      {required WidgetRef ref, triggeredByDrag = true}) {
    if (key.currentState?.type == currentSheetType) {
      currentSheetType = null;
      ref.read(menuProvider.notifier).closeSub();
    }
    if (triggeredByDrag) {
      ref.read(menuProvider.notifier).openTop();
    }
  }

  void toggleMenu(WidgetRef ref) {
    final menuVisible = ref.read(menuProvider);
    if (!ref.read(ProviderUsecase().catalog).hasValue) {
      return;
    }
    if (menuVisible.sub) {
      sheetKeys
          .firstWhere((key) => key.currentState?.isVisible ?? false)
          .currentState
          ?.hide();
      ref.read(menuProvider.notifier).closeSub();
      ref.read(menuProvider.notifier).openTop();
    } else {
      if (menuVisible.none) {
        ref.read(menuProvider.notifier).openParent();
      } else {
        ref.read(menuProvider.notifier).closeParent();
      }
    }
  }

  void toggleSheet(
    GlobalKey<PersistentBottomSheetState> key, {
    required WidgetRef ref,
  }) {
    for (var sheetKey in sheetKeys) {
      if (sheetKey == key) {
        if (sheetKey.currentState?.isVisible ?? false) {
          sheetKey.currentState?.hide();
          currentSheetType = null;
          ref.read(menuProvider.notifier).openTop();
          ref.read(menuProvider.notifier).closeSub();
        } else {
          sheetKey.currentState?.show();
          currentSheetType = sheetKey.currentState!.type;
          ref.read(menuProvider.notifier).openSub(currentSheetType!);
        }
      } else {
        sheetKey.currentState?.hide();
      }
    }
  }

  closeAll(dynamic ref) {
    for (var sheetKey in sheetKeys) {
      sheetKey.currentState?.hide();
    }
    ref.read(menuProvider.notifier).closeSub();
    ref.read(menuProvider.notifier).closeParent();
  }

  List<GlobalKey<PersistentBottomSheetState>> get sheetKeys => [
        catalogSheetKey,
        fontSheetKey,
        themeSheetKey,
        configSheetKey,
      ];
}
