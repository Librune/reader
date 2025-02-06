import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/ui/components/sheets/theme_card.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

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
            MenuSheetUsecase().toggle(ThemeSheetContent(),
                type: ReaderBottomSheet.theme, maxHeight: MediaQuery.of(context).size.height * 0.5, ref: ref);
          },
        ),
      ),
    );
  }
}

class ThemeSheetContent extends StatefulHookConsumerWidget {
  const ThemeSheetContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSheetContentState();
}

class _ThemeSheetContentState extends ConsumerState<ThemeSheetContent> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(ProviderUsecase().config.select((value) => value.theme));
    final themes = ref.watch(ProviderUsecase().theme).value ?? [];
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          sliver: SliverGrid.extent(
            maxCrossAxisExtent: 220,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              ...themes.map((theme) => ThemeSheetCard(
                    colorScheme: theme.colorScheme,
                    id: theme.id,
                    name: theme.name,
                    author: theme.author,
                    isSelected: currentTheme == theme.id,
                    onSelect: (id) {
                      ref.read(ProviderUsecase().config.notifier).updateTheme(id);
                    },
                  )),
            ],
          ),
        )
      ],
    );
  }
}
