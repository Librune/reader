import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:reader/app/transparent_app.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //next tick
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // MacosWindowUtils.setSidebarWidth(200);

      // WindowManipulator.setMaterial(NSVisualEffectViewMaterial.sidebar);
    });
    return CupertinoApp.router(
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
        scaffoldBackgroundColor: CupertinoColors.white,
      ),
      routerConfig: router,
    );
  }
}
