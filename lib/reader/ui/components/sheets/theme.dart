import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/ui/components/sheets/theme_card.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

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
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 8),
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
