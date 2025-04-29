import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReaderTopBar extends StatefulHookConsumerWidget {
  const ReaderTopBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReaderTopBarState();
}

class _ReaderTopBarState extends ConsumerState<ReaderTopBar> {
  final String bookTitle = "三体";
  final String chapterTitle = "第一章 科学边界";
  final String authorName = "刘慈欣";
  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    final shwoToc = useState(false);
    return Container(
      height: 36,
      padding: EdgeInsets.only(top: 0, left: 76),
      decoration: BoxDecoration(
        color: themeData.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        spacing: 14,
        children: [
          // 目录按钮
          ShadIconButton.outline(
            width: 24,
            height: 24,
            decoration: ShadDecoration(),
            icon: SvgPicture.asset(
              shwoToc.value
                  ? "assets/svg/ic_menu_fold.svg"
                  : "assets/svg/ic_menu.svg",
              width: 15,
            ),
            onPressed: () {
              setState(() {
                shwoToc.value = !shwoToc.value;
              });
            },
          ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: bookTitle,
                  style: TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' · ',
                  style: TextStyle(
                    color: CupertinoColors.black.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: chapterTitle,
                  style: TextStyle(
                    color: CupertinoColors.black.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // 右侧工具按钮
          ShadIconButton.ghost(
            width: 24,
            height: 24,
            icon: SvgPicture.asset("assets/svg/ic_bookmark.svg", width: 16),
            onPressed: () {},
          ),
          ShadIconButton.ghost(
            width: 24,
            height: 24,
            icon: SvgPicture.asset(
              "assets/svg/ic_font_settings.svg",
              width: 16,
            ),
          ),
          SizedBox(width: 0),
        ],
      ),
    );
  }
}
