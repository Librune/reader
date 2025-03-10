import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/app/components/content_area.dart';
import 'package:reader_macos/app/components/toast.dart';
import 'package:reader_macos/book_source_list/components/detail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'components/item.dart';

class BookSourceListScreen extends StatefulHookConsumerWidget {
  const BookSourceListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceListScreenState();
}

class _BookSourceListScreenState extends ConsumerState<BookSourceListScreen> {
  final log = Logger('a_context');
  @override
  Widget build(BuildContext context) {
    return ContentArea(
      title: "书源",
      subtitle: "本机安装的全部书源",
      action: Row(
        spacing: 10,
        children: [
          Spacer(),
          ShadButton.secondary(
            height: 28,
            child: const Text('本地添加', style: TextStyle(fontSize: 12)),
            onPressed: () {
              ref.read(bookSourceProvider.notifier).addFromFile();
            },
          ),
          ShadButton.secondary(
            height: 28,
            child: const Text('网络导入', style: TextStyle(fontSize: 12)),
            onPressed: () {
              // appToast.showToast(child: const Text('网络导入'));
              ToastUtil.info('网络导入');
              log.info('网络导入');
            },
          ),
          ShadButton.secondary(height: 28, child: const Text('在线调试', style: TextStyle(fontSize: 12)), onPressed: () {}),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(left: 18, right: 24, bottom: 12, top: 8),
        child: Row(
          spacing: 20,
          children: [
            Expanded(
              flex: 1,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return BookSourceItem(checked: index == 0);
                },
                separatorBuilder: (context, index) {
                  return Container(height: 1);
                },
                itemCount: 1,
              ),
            ),
            Expanded(child: BookSourceDetail(), flex: 1),
          ],
        ),
      ),
    );
  }
}
