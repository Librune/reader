import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/ui/components/sheets/theme_card.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';

class ThemeSheet extends ConsumerWidget {
  const ThemeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subType = ref.watch(menuProvider.select((value) => value.subType));
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: 1,
      child: Center(
        child: SvgBtn(
          svgName: 'ic_bottom_sun',
          size: 26,
          color: ReaderBottomSheet.theme == subType ? colorScheme.primary : null,
          onPressed: () {
            MenuSheetUsecase().toggle(
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid.extent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          ThemeSheetCard(
                            colorScheme: colorScheme,
                            image: CachedNetworkImageProvider(
                                "https://c-ssl.dtstatic.com/uploads/blog/202301/08/20230108234729_02a0d.thumb.700_0.jpg_webp"),
                            name: "默认",
                            author: "zsakvo",
                            isSelected: true,
                            onSelect: (value) {
                              Log.f("select: $value");
                            },
                          ),
                          ThemeSheetCard(
                            colorScheme: colorScheme,
                            image: CachedNetworkImageProvider(
                                "https://c-ssl.dtstatic.com/uploads/blog/202301/08/20230108234729_02a0d.thumb.700_0.jpg_webp"),
                            name: "默认",
                            author: "zsakvo",
                            isSelected: true,
                            onSelect: (value) {
                              Log.f("select: $value");
                            },
                          ),
                          ThemeSheetCard(
                            colorScheme: colorScheme,
                            image: CachedNetworkImageProvider(
                                "https://c-ssl.dtstatic.com/uploads/blog/202301/08/20230108234729_02a0d.thumb.700_0.jpg_webp"),
                            name: "默认",
                            author: "zsakvo",
                            isSelected: true,
                            onSelect: (value) {
                              Log.f("select: $value");
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
                type: ReaderBottomSheet.theme,
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                ref: ref);
          },
        ),
      ),
    );
  }
}
