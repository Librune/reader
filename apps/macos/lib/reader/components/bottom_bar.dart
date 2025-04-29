import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReaderBottomBar extends StatefulHookConsumerWidget {
  const ReaderBottomBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReaderBottomBarState();
}

class _ReaderBottomBarState extends ConsumerState<ReaderBottomBar> {
  final int totalChapters = 42;
  final int currentChapterIndex = 1;

  // 模拟进度
  double _readingProgress = 0.0;
  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: themeData.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 上一章
          ShadButton.ghost(
            leading: Icon(
              CupertinoIcons.chevron_back,
              size: 14,
              color: CupertinoColors.black.withOpacity(0.7),
            ),
            child: Text(
              '上一章',
              style: TextStyle(
                color: CupertinoColors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            onPressed: () {},
          ),

          SizedBox(width: 16),

          // 章节导航控件
          Text(
            '${currentChapterIndex}/${totalChapters}',
            style: TextStyle(
              color: CupertinoColors.black.withOpacity(0.7),
              fontSize: 12,
            ),
          ),

          SizedBox(width: 16),

          // 下一章
          ShadButton.ghost(
            leading: Text(
              '下一章',
              style: TextStyle(
                color: CupertinoColors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            child: Icon(
              CupertinoIcons.chevron_forward,
              size: 14,
              color: CupertinoColors.black.withOpacity(0.7),
            ),

            onPressed: () {},
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: ShadSlider(
                thumbColor: CupertinoColors.black,
                thumbBorderColor: CupertinoColors.transparent,
                activeTrackColor: CupertinoColors.black,
                initialValue: _readingProgress,
                trackHeight: 6,
                thumbRadius: 4,
                onChanged: (value) {
                  setState(() {
                    _readingProgress = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
