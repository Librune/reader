import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }
  await initCoreServices();
  runApp(ProviderScope(child: const MyApp()));
}

Future<void> _configureMacosWindowUtils() async {
  // const config = MacosWindowUtilsConfig(toolbarStyle: NSWindowToolbarStyle.expanded);
  // await config.apply();
  // await WindowManipulator.setMaterial(NSVisualEffectViewMaterial.titlebar);
  await WindowManipulator.initialize(enableWindowDelegate: true);
  await WindowManipulator.setMaterial(NSVisualEffectViewMaterial.titlebar);
  await WindowManipulator.enableFullSizeContentView();
  await WindowManipulator.makeTitlebarTransparent();
  await WindowManipulator.hideTitle();
  await WindowManipulator.setToolbarStyle(toolbarStyle: NSWindowToolbarStyle.unifiedCompact);
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bookSourceProvider);
    return ShadApp.cupertinoRouter(
      theme: ShadThemeData(brightness: Brightness.light, colorScheme: ShadColorScheme.fromName('blue')),
      routerConfig: router,
      builder:
          (context, child) => Overlay(
            initialEntries: [
              if (child != null) ...[OverlayEntry(builder: (context) => child)],
            ],
          ),
    );
  }
}
