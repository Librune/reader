import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/hooks/use_brightness.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/ui/router.dart';
import 'package:reader/app/ui/theme/theme.dart';
import 'package:reader/app/provider/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PathService().init();
  await BookSourceService().init();
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
      position: IndicatorPosition.locator,
      dragText: "下拉刷新",
      armedText: "释放开始",
      readyText: "刷新中……",
      processingText: "刷新中",
      processedText: "成功了",
      noMoreText: "没有更多",
      failedText: "失败了",
      messageText: "最后更新于 %T");
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
        position: IndicatorPosition.locator,
        dragText: '上拉加载',
        armedText: '释放开始',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '成功了',
        noMoreText: '没有更多',
        failedText: '失败了',
        messageText: '最后更新于 %T',
      );
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
