import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/components/content_area.dart';

class BookSourceListScreen extends StatefulHookConsumerWidget {
  const BookSourceListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceListScreenState();
}

class _BookSourceListScreenState extends ConsumerState<BookSourceListScreen> {
  @override
  Widget build(BuildContext context) {
    return ContentArea(
      title: "书源",
      subtitle: "本机安装的全部书源",
      child: Container(
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 12),

        child: Row(
          spacing: 16,
          children: [
            Expanded(child: Container(color: CupertinoColors.activeBlue), flex: 1),
            Expanded(child: Container(color: CupertinoColors.activeBlue), flex: 1),
          ],
        ),
      ),
    );
  }
}
