import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_source/ui/components/book_source_item.dart';

import '../provider/book_source_provider.dart';

class BookSourceListScreen extends HookConsumerWidget {
  const BookSourceListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksource = ref.watch(bookSourceProvider);
    return Scaffold(
        appBar: AppTopBar(
          title: "书源列表",
          actions: [
            SvgBtn(
              svgName: "ic_btn_plus",
              onPressed: () {
                ref.read(bookSourceProvider.notifier).pickNew();
              },
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: switch (booksource) {
              AsyncValue(:final value?) => ListView.separated(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final bks = value[index];
                    return BookSourceItem(
                      source: bks,
                      onPressed: () {
                        context.push("/book_source/detail/1");
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 12,
                    );
                  },
                ),
              _ => Center(
                  child: CircularProgressIndicator(),
                ),
            }));
  }
}
