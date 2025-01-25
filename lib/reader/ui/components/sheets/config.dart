import 'package:flutter/material.dart';
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
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ListTile(
                            title: Text('设置'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                type: ReaderBottomSheet.config,
                ref: ref);
          },
        ),
      ),
    );
  }
}
