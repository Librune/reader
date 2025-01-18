import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/preference/provider/preference_provider.dart';

import 'components/pereference_item.dart';
import 'components/preference_section.dart';

class PreferenceScreen extends HookConsumerWidget {
  const PreferenceScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(preferenceProvider);
    return Scaffold(
      appBar: AppTopBar(
        title: '应用设置',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PreferenceSection(title: "书籍阅读", children: [
              PreferenceTap(
                title: "来源管理",
                subtitle: "C、R、U、D 书籍来源",
                onTap: () {
                  context.push('/book_source');
                },
              ),
              PreferenceTap(
                  title: "正则管理",
                  subtitle: "管理应用内可能用到的正则表达式",
                  onTap: () {
                    // context.push("/palette");
                    // ref.read(preferenceProvider.notifier).onEvent();
                  }),
              PreferenceSwitch(
                title: "Web 服务",
                subtitle: "提供外部操作接口",
                value: preference.autoDarkMode,
                onChanged: (value) {
                  ref.read(preferenceProvider.notifier).updateAutoDarkMode(value);
                },
              ),
            ]),
            PreferenceSection(title: "用户界面", children: [
              PreferenceSwitch(
                title: "自动暗色",
                subtitle: "跟随系统设置自动开启或关闭暗色模式",
                value: preference.autoDarkMode,
                onChanged: (value) {
                  ref.read(preferenceProvider.notifier).updateAutoDarkMode(value);
                },
              ),
              if (!preference.autoDarkMode)
                PreferenceSwitch(
                  title: "夜间模式",
                  subtitle: "将 APP 切换到暗色主题",
                  onChanged: (value) {
                    ref.read(preferenceProvider.notifier).updateIsDarkMode(value);
                  },
                  value: preference.isDarkMode,
                ),
              PreferenceTap(
                  title: "主题颜色",
                  subtitle: "选择一个颜色作为种子生成主题配色",
                  onTap: () {
                    // context.push("/palette");
                    // ref.read(preferenceProvider.notifier).onEvent();
                  }),
            ]),
            PreferenceSection(title: "应用数据", children: [
              PreferenceTap(
                title: "备份与恢复",
                subtitle: "备份与恢复应用数据",
                onTap: () {},
              ),
              PreferenceSwitch(
                title: "安全启动",
                subtitle: "启动时需要进行身份验证",
                value: preference.autoDarkMode,
                onChanged: (value) {
                  ref.read(preferenceProvider.notifier).updateAutoDarkMode(value);
                },
              ),
            ]),
            PreferenceSection(title: "其它", padding: EdgeInsets.all(16), children: [
              PreferenceTap(
                  title: "关于",
                  subtitle: "更新日志，问题反馈，联系作者",
                  onTap: () {
                    // context.push("/palette");
                    // ref.read(preferenceProvider.notifier).onEvent();
                  }),
              PreferenceTap(
                  title: "恢复默认",
                  subtitle: "擦除所有设置，恢复到默认状态",
                  onTap: () {
                    // context.push("/palette");
                    // ref.read(preferenceProvider.notifier).onEvent();
                  }),
            ]),
          ],
        ),
      ),
    );
  }
}
