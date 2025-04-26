import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReaderTopBar extends StatefulHookConsumerWidget {
  const ReaderTopBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReaderTopBarState();
}

class _ReaderTopBarState extends ConsumerState<ReaderTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 目录按钮
          IconButton(
            icon: Icon(
              _showTableOfContents ? Icons.menu_open : Icons.menu,
              color: _textColor,
            ),
            onPressed: () {
              setState(() {
                _showTableOfContents = !_showTableOfContents;
              });
            },
            tooltip: '目录',
          ),

          // 标题
          Text(
            bookTitle,
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            ' · ',
            style: TextStyle(color: _textColor.withOpacity(0.5), fontSize: 16),
          ),
          Expanded(
            child: Text(
              chapterTitle,
              style: TextStyle(
                color: _textColor.withOpacity(0.8),
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 右侧工具按钮
          IconButton(
            icon: Icon(Icons.bookmark_border, color: _textColor),
            onPressed: () {},
            tooltip: '书签',
          ),
          IconButton(
            icon: Icon(Icons.text_fields, color: _textColor),
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
            tooltip: '阅读设置',
          ),
        ],
      ),
    );
  }
}
