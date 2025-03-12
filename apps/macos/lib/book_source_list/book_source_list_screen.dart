import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
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
  final log = Logger('book_source_list_screen');
  @override
  Widget build(BuildContext context) {
    final booksourceList = ref.watch(bookSourceProvider);
    final netDev = useState(false);
    final currentBookSourceIndex = useState(0);
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
          netDev.value
              ? ShadButton.secondary(
                height: 28,
                child: const Text('在线调试', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  netDev.value = !netDev.value;
                  log.info('在线调试');
                },
              )
              : ShadButton(
                height: 28,
                child: const Text('在线调试', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  netDev.value = !netDev.value;
                  log.info('在线调试');
                },
              ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(left: 18, right: 24, bottom: 12, top: 0),
        child: Row(
          spacing: 20,
          children: [
            Expanded(
              flex: 1,
              child: switch (booksourceList) {
                AsyncData(:final value) =>
                  value.isEmpty
                      ? NoBookSource()
                      : ListView.separated(
                        itemBuilder: (context, index) {
                          final model = value[index];
                          return GestureDetector(
                            child: BookSourceItem(checked: currentBookSourceIndex.value == index, model: model),
                            onTap: () {
                              // currentBookSourceModel.value = model;
                              currentBookSourceIndex.value = index;
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(height: 1);
                        },
                        itemCount: value.length,
                      ),
                _ => const Center(child: NoBookSource()),
              },
            ),
            booksourceList.value == null
                ? SizedBox.shrink()
                : Expanded(
                  flex: 1,
                  child: BookSourceDetail(model: booksourceList.value![currentBookSourceIndex.value]),
                ),
          ],
        ),
      ),
    );
  }
}

class NoBookSource extends StatelessWidget {
  const NoBookSource({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Column(
        children: [
          SvgPicture.asset("assets/svg/il_empty.svg"),
          Transform.translate(
            offset: Offset(0, -56),
            child: Text("暂无书源，请先添加", style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
