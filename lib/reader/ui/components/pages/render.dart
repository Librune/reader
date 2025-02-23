import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/provider/battery.dart';
import 'package:reader/reader/provider/extra.dart';
import 'package:reader/reader/provider/time.dart';

import '../render.dart';

class TextPageRender extends StatefulHookConsumerWidget {
  const TextPageRender({
    super.key,
    required this.pagePainter,
  });
  final PagePainter pagePainter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextPageRenderState();
}

class _TextPageRenderState extends ConsumerState<TextPageRender> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pagePainter = widget.pagePainter;
    final extraConfig = ref.watch(readerExtraConfigProvider);
    final infoTextStyle = pagePainter.infoTextStyle.copyWith(color: colorScheme.onSurface.withOpacity(.5));
    final batteryInfo = ref.watch(readerBatteryProvider);
    final timeInfo = ref.watch(readerTimeProvider);
    return Stack(
      children: [
        ...pagePainter.painters.map((painter) {
          double posY = painter.posY;
          double posX = painter.posX;
          if (painter.paraLineIndex > -1) {
            posY += pagePainter.extraParaPadding * (painter.paraLineIndex + painter.pageIndex == 0 ? 0 : 1);
          } else {
            posX += 8.0;
          }
          return Positioned(
            left: posX,
            top: posY,
            right: painter.paraLineIndex == -1 ? posX : 0,
            child: Text.rich(
              TextSpan(
                text: painter.text,
                style: painter.renderStyle.copyWith(color: colorScheme.onSurface),
              ),
            ),
          );
        }),
        if (pagePainter.pageIndex == 0)
          Positioned(
            left: pagePainter.titleIndicatorPosX,
            top: pagePainter.titleIndicatorPosY,
            child: Container(
              width: 5,
              height: pagePainter.titleIndicatorHeight,
              color: colorScheme.primary,
            ),
          ),
        Positioned(
            left: pagePainter.topInfoPadding.left,
            top: pagePainter.topInfoPadding.top,
            right: pagePainter.topInfoPadding.right,
            child: Row(
              children: [
                Text(pagePainter.pageIndex == 0 ? pagePainter.bookName : pagePainter.chapterName, style: infoTextStyle),
              ],
            )),
        Positioned(
            left: pagePainter.bottomInfoPadding.left,
            bottom: pagePainter.bottomInfoPadding.bottom,
            right: pagePainter.bottomInfoPadding.right,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (extraConfig.showTimeBattery)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(timeInfo, style: infoTextStyle),
                  ),
                if (extraConfig.showTimeBattery)
                  Transform.rotate(
                    angle: 3.14 / 2,
                    child: Icon(batteryInfo.value!.icon, size: 22, color: infoTextStyle.color),
                  ),
                const Spacer(),
                Text("${pagePainter.pageIndex + 1}/${pagePainter.totalPages}", style: infoTextStyle),
              ],
            ))
      ],
    );
  }
}
