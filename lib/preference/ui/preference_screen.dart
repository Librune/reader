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
          ],
        ),
      ),
    );
  }
}
