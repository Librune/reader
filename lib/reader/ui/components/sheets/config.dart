import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class ConfigButton extends HookConsumerWidget {
  const ConfigButton({super.key, required this.iconPath, required this.label, this.enabled = false, this.onPressed});
  final String iconPath;
  final bool enabled;
  final String label;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      spacing: 6,
      children: [
        IconButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.all(13)),
            backgroundColor:
                WidgetStateProperty.all(enabled ? colorScheme.secondaryContainer : colorScheme.surfaceContainerHigh),
          ),
          onPressed: () {
            onPressed?.call();
          },
          icon: SvgPicture.asset("assets/svg/$iconPath.svg",
              width: 25,
              height: 25,
              colorFilter: ColorFilter.mode(
                enabled ? colorScheme.primary : colorScheme.secondary.withAlpha(180),
                BlendMode.srcIn,
              )),
        ),
        Text(label,
            style: TextStyle(
                color: enabled ? colorScheme.primary : colorScheme.secondary,
                fontSize: 12,
                fontWeight: enabled ? FontWeight.normal : null))
      ],
    );
  }
}

class ConfigSheetContent extends StatefulHookConsumerWidget {
  const ConfigSheetContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigSheetContentState();
}

class _ConfigSheetContentState extends ConsumerState<ConfigSheetContent> {
  @override
  Widget build(BuildContext context) {
    final extra = ref.watch(ProviderUsecase().extra);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 16),
          sliver: SliverGrid.extent(
              maxCrossAxisExtent: 96,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: [
                ConfigButton(
                    iconPath: "ic_reader_config_vertical",
                    label: "垂直滚动",
                    enabled: extra.verticalScroll,
                    onPressed: () {
                      ref.read(ProviderUsecase().extra.notifier).updatePageTurning('verticalScroll');
                    }),
                ConfigButton(
                    iconPath: "ic_reader_config_slider",
                    label: "横向滑动",
                    enabled: extra.horizontalScroll,
                    onPressed: () {
                      ref.read(ProviderUsecase().extra.notifier).updatePageTurning('horizontalScroll');
                    }),
                ConfigButton(
                    iconPath: "ic_reader_config_curl",
                    label: "仿真翻页",
                    enabled: extra.curlPage,
                    onPressed: () {
                      ref.read(ProviderUsecase().extra.notifier).updatePageTurning('curlPage');
                    }),
                ConfigButton(
                    iconPath: "ic_reader_config_flip",
                    label: "分层拂动",
                    enabled: extra.flipPage,
                    onPressed: () {
                      ref.read(ProviderUsecase().extra.notifier).updatePageTurning('flipPage');
                    }),
                ConfigButton(iconPath: "ic_reader_config_locate", label: "定位页面"),
                ConfigButton(iconPath: "ic_reader_config_search", label: "搜索内容"),
                ConfigButton(iconPath: "ic_reader_config_tea", label: "禅模式", enabled: extra.zenMode),
                ConfigButton(iconPath: "ic_reader_config_chart", label: "统计数据"),
                ConfigButton(iconPath: "ic_reader_config_anchor", label: "全屏下一页", enabled: extra.fullScreenNext),
                ConfigButton(iconPath: "ic_reader_config_finger", label: "点按动画", enabled: extra.tapAnimation),
                ConfigButton(iconPath: "ic_reader_config_landscape", label: "背景跟随", enabled: extra.backgroundFollow),
                ConfigButton(iconPath: "ic_reader_config_bookmark", label: "下拉书签", enabled: extra.pullBookmark),
                ConfigButton(iconPath: "ic_reader_config_lock", label: "屏幕常亮", enabled: extra.keepScreenOn),
                ConfigButton(iconPath: "ic_reader_config_links", label: "访问来源"),
              ]),
        )
      ],
    );
  }
}
