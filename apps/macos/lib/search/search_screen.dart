import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/app/components/content_area.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SearchScreen extends StatefulHookConsumerWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final log = Logger('search_screen');
  @override
  Widget build(BuildContext context) {
    return ContentArea(
      title: "搜索",
      subtitle: "按关键字搜索书籍",
      action: Row(
        children: [
          Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: ShadInput(
              decoration: ShadDecoration(
                secondaryBorder: ShadBorder.all(color: CupertinoColors.systemGrey3, padding: EdgeInsets.zero),
                secondaryFocusedBorder: ShadBorder.all(width: 0, padding: EdgeInsets.zero),
                // descriptionPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 13),
              placeholderStyle: TextStyle(fontSize: 13),
              cursorHeight: 14,
              placeholder: Text('搜索书籍或作者'),
              cursorColor: CupertinoColors.systemGrey,
              keyboardType: TextInputType.name,
              leading: Icon(CupertinoIcons.search, size: 16, color: CupertinoColors.systemGrey),
              onSubmitted: (value) {
                log.info('搜索', value);
              },
            ),
          ),
        ],
      ),
      child: Container(),
    );
  }
}
