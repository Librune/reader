import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';

class ConfigSheet extends HookConsumerWidget {
  const ConfigSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subType = ref.watch(menuProvider.select((value) => value.subType));
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: 1,
      child: Center(
        child: SvgBtn(
          svgName: 'ic_bottom_settings',
          size: 26,
          color: ReaderBottomSheet.config == subType ? colorScheme.primary : null,
          onPressed: () {
            MenuSheetUsecase().toggle(
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid.extent(
                          maxCrossAxisExtent: 96,
                          childAspectRatio: 1,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: [
                            ConfigButton(
                              iconPath: "ic_reader_config_vertical",
                              label: "垂直滚动",
                              isSelected: true,
                            ),
                            ConfigButton(iconPath: "ic_reader_config_slider", label: "横向滑动"),
                            ConfigButton(iconPath: "ic_reader_config_curl", label: "仿真翻页"),
                            ConfigButton(iconPath: "ic_reader_config_flip", label: "分层拂动"),
                            ConfigButton(iconPath: "ic_reader_config_locate", label: "定位页面"),
                            ConfigButton(iconPath: "ic_reader_config_search", label: "搜索内容"),
                            ConfigButton(iconPath: "ic_reader_config_tea", label: "禅模式"),
                            ConfigButton(iconPath: "ic_reader_config_chart", label: "统计数据"),
                            ConfigButton(iconPath: "ic_reader_config_anchor", label: "全屏下一页"),
                            ConfigButton(iconPath: "ic_reader_config_finger", label: "点按动画"),
                            ConfigButton(iconPath: "ic_reader_config_landscape", label: "背景跟随"),
                            ConfigButton(iconPath: "ic_reader_config_bookmark", label: "下拉书签"),
                            ConfigButton(iconPath: "ic_reader_config_lock", label: "屏幕常亮"),
                            ConfigButton(iconPath: "ic_reader_config_links", label: "访问来源"),
                          ]),
                    )
                  ],
                ),
                type: ReaderBottomSheet.config,
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                ref: ref);
          },
        ),
      ),
    );
  }
}

class ConfigButton extends HookConsumerWidget {
  const ConfigButton({super.key, required this.iconPath, required this.label, this.isSelected = false});
  final String iconPath;
  final bool isSelected;
  final String label;
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
                WidgetStateProperty.all(isSelected ? colorScheme.secondaryContainer : colorScheme.surfaceContainerHigh),
          ),
          onPressed: () {},
          icon: SvgPicture.asset("assets/svg/$iconPath.svg",
              width: 25,
              height: 25,
              colorFilter: ColorFilter.mode(
                isSelected ? colorScheme.primary : colorScheme.secondary.withAlpha(180),
                BlendMode.srcIn,
              )),
        ),
        Text(label,
            style: TextStyle(
                color: isSelected ? colorScheme.primary : colorScheme.secondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.normal : null))
      ],
    );
  }
}
