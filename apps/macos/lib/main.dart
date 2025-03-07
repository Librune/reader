import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

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
  const config = MacosWindowUtilsConfig();
  await config.apply();
  await WindowManipulator.setMaterial(NSVisualEffectViewMaterial.sidebar);
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
    return MacosApp(
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      // routerConfig: router,
    );
  }
}
