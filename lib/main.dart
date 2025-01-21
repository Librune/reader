import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/hooks/use_brightness.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/ui/router.dart';
import 'package:reader/app/ui/theme/theme.dart';
import 'package:reader/app/provider/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PathService().init();
  runApp(const ProviderScope(child: ReaderApp()));
}

class ReaderApp extends HookConsumerWidget {
  const ReaderApp({super.key});
  final bool useMaterial3 = true;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(appProvider.select((value) => value.preference));
    useBrightness(context, autoDarkMode: preference.autoDarkMode, isDarkMode: preference.isDarkMode);
    return MaterialApp.router(
      title: '阅读',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: preference.colorMode,
      routerConfig: router,
    );
  }
}
