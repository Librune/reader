import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class BookSourceListScreen extends StatefulHookConsumerWidget {
  const BookSourceListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceListScreenState();
}

class _BookSourceListScreenState extends ConsumerState<BookSourceListScreen> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('书源列表'),
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
            icon: const MacosIcon(CupertinoIcons.add_circled),
            onPressed: () => debugPrint('New Folder...'),
            label: 'New Folder',
            showLabel: false,
            tooltipMessage: 'This is a beautiful tooltip',
          ),
          ToolBarIconButton(
            icon: const MacosIcon(CupertinoIcons.compass),
            onPressed: () => debugPrint('New Folder...'),
            label: 'New Folder',
            showLabel: false,
            tooltipMessage: 'This is a beautiful tooltip',
          ),
          ToolBarIconButton(
            icon: const MacosIcon(CupertinoIcons.sidebar_right),
            onPressed: () => debugPrint('New Folder...'),
            label: 'New Folder',
            showLabel: false,
            tooltipMessage: 'This is a beautiful tooltip',
          ),
        ],
      ),
      children: [
        ResizablePane(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 700,
          resizableSide: ResizableSide.right,
          builder: (_, __) {
            return const Center(child: Text('Left Resizable Pane'));
          },
        ),
        ContentArea(
          builder: (_, __) {
            return Column(children: [const Flexible(fit: FlexFit.loose, child: Center(child: Text('Content Area')))]);
          },
        ),
      ],
    );
  }
}
