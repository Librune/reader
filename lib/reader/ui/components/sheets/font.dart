import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/cust_slider/cust_thumb_shape.dart';
import 'package:reader/app/ui/components/cust_slider/cust_track_shape.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class FontSheet extends StatefulHookConsumerWidget {
  const FontSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FontSheetState();
}

class _FontSheetState extends ConsumerState<FontSheet> {
  @override
  Widget build(BuildContext context) {
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
            MenuSheetUsecase().toggle(FontSheetContent(), type: ReaderBottomSheet.font, ref: ref, maxHeight: 360);
          },
        ),
      ),
    );
  }
}

class FontSheetContent extends StatefulHookConsumerWidget {
  const FontSheetContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FontSheetContentState();
}

class _FontSheetContentState extends ConsumerState<FontSheetContent> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bodyTextFontSize = useState(ref.read(ProviderUsecase().config).bodyTextFontSize);
    final bodyTextLineHeight = useState(ref.read(ProviderUsecase().config).bodyTextLineHeight);
    final edgePaddingDelta = useState(ref.read(ProviderUsecase().config).edgePaddingDelta);
    return Padding(
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
                    text: "字号",
                    buildContext: context,
                    enabledThumbRadius: 15, //滑块大小
                  ),
                ),
                child: Slider(
                    value: bodyTextFontSize.value,
                    min: 10.0,
                    max: 42.0,
                    onChanged: (val) {
                      bodyTextFontSize.value = val;
                    },
                    onChangeEnd: (val) {
                      ref.read(ProviderUsecase().config.notifier).updateBodyFontSize(bodyTextFontSize.value.toInt());
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
                    text: "行高",
                    buildContext: context,
                    enabledThumbRadius: 15, //滑块大小
                  ),
                ),
                child: Slider(
                    value: bodyTextLineHeight.value,
                    min: 1.0,
                    max: 3.0,
                    onChanged: (val) {
                      bodyTextLineHeight.value = val;
                    },
                    onChangeEnd: (val) {
                      // ref
                      //     .read(readerConfigProvider.notifier)
                      //     .updateReaderConfig("bodyTextLineHeight", bodyTextLineHeight.value);
                      ref.read(ProviderUsecase().config.notifier).updateBodyLineHeight(bodyTextLineHeight.value);
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
            children: [
              SvgPicture.asset(
                "assets/svg/ic_slider_ruler.svg",
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
                    text: "边距",
                    buildContext: context,
                    enabledThumbRadius: 15, //滑块大小
                  ),
                ),
                child: Slider(
                    value: edgePaddingDelta.value,
                    min: 0.0,
                    max: 24.0,
                    onChanged: (val) {
                      edgePaddingDelta.value = val;
                    },
                    onChangeEnd: (val) {
                      ref.read(ProviderUsecase().config.notifier).updateEdgePaddingDelta(edgePaddingDelta.value);
                    }),
              )),
              SvgPicture.asset(
                "assets/svg/ic_slider_ruler.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                        backgroundColor: WidgetStateProperty.all(colorScheme.secondaryContainer),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      onPressed: () {},
                      child: Text("选择字体")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
