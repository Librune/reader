import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/cust_slider/cust_thumb_shape.dart';
import 'package:reader/app/ui/components/cust_slider/cust_track_shape.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';

class FontSheet extends HookConsumerWidget {
  const FontSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subType = ref.watch(menuProvider.select((value) => value.subType));
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: 1,
      child: Center(
        child: SvgBtn(
          svgName: 'ic_bottom_font',
          size: 26,
          color: ReaderBottomSheet.font == subType ? colorScheme.primary : null,
          onPressed: () {
            MenuSheetUsecase().toggle(
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/ic_slider_font.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                          ),
                          Flexible(
                              child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: colorScheme.secondaryContainer,
                              inactiveTrackColor: colorScheme.surfaceContainerHighest,
                              trackHeight: 32,
                              trackShape: CustTrackShape(),
                              overlayShape: SliderComponentShape.noOverlay,
                              thumbColor: colorScheme.surface,
                              thumbShape: CustomThumbShape(
                                text: "2.2",
                                buildContext: context,
                                enabledThumbRadius: 15, //滑块大小
                              ),
                            ),
                            child: Slider(
                                value: 2.2,
                                min: 1.0,
                                max: 3.0,
                                onChanged: (val) {
                                  // bodyTextLineHeight.value = val;
                                },
                                onChangeEnd: (val) {
                                  // ref
                                  //     .read(readerConfigProvider.notifier)
                                  //     .updateReaderConfig("bodyTextLineHeight", bodyTextLineHeight.value);
                                }),
                          )),
                          SvgPicture.asset(
                            "assets/svg/ic_slider_font.svg",
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/ic_slider_menu.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                          ),
                          Flexible(
                              child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: colorScheme.secondaryContainer,
                              inactiveTrackColor: colorScheme.surfaceContainerHighest,
                              trackHeight: 32,
                              trackShape: CustTrackShape(),
                              overlayShape: SliderComponentShape.noOverlay,
                              thumbColor: colorScheme.surface,
                              thumbShape: CustomThumbShape(
                                text: "2.2",
                                buildContext: context,
                                enabledThumbRadius: 15, //滑块大小
                              ),
                            ),
                            child: Slider(
                                value: 2.2,
                                min: 1.0,
                                max: 3.0,
                                onChanged: (val) {
                                  // bodyTextLineHeight.value = val;
                                },
                                onChangeEnd: (val) {
                                  // ref
                                  //     .read(readerConfigProvider.notifier)
                                  //     .updateReaderConfig("bodyTextLineHeight", bodyTextLineHeight.value);
                                }),
                          )),
                          SvgPicture.asset(
                            "assets/svg/ic_slider_menu.svg",
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                  backgroundColor: WidgetStateProperty.all(colorScheme.secondaryContainer),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                ),
                                onPressed: () {},
                                child: Text("默认字体")),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                  backgroundColor: WidgetStateProperty.all(colorScheme.secondaryContainer),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                ),
                                onPressed: () {},
                                child: Text("选择字体")),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                type: ReaderBottomSheet.font,
                ref: ref,
                maxHeight: 284);
          },
        ),
      ),
    );
  }
}
