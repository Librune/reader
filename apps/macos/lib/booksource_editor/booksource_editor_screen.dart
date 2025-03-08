import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class BooksourceEditorScreen extends StatefulHookConsumerWidget {
  const BooksourceEditorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BooksourceEditorScreenState();
}

class _BooksourceEditorScreenState extends ConsumerState<BooksourceEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: MacosColors.white));
    MacosScaffold(
      toolBar: ToolBar(
        title: const Text('编辑书源'),
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(
                context,
              ).resolve(const Color.fromRGBO(0, 0, 0, 0.5), const Color.fromRGBO(255, 255, 255, 0.5)),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(minHeight: 20, minWidth: 20, maxWidth: 48, maxHeight: 38),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
        actions: [
          ToolBarIconButton(
            label: 'Toggle End Sidebar',
            tooltipMessage: 'Toggle End Sidebar',
            icon: const MacosIcon(CupertinoIcons.sidebar_right),
            onPressed: () => MacosWindowScope.of(context).toggleEndSidebar(),
            showLabel: false,
          ),
        ],
      ),
    );
  }
}
