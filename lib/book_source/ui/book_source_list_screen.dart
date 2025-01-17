import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/svg_btn.dart';

class BookSourceListScreen extends HookConsumerWidget {
  const BookSourceListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppTopBar(
          title: "书源列表",
          actions: [SvgBtn(svgName: "ic_btn_plus")],
        ),
        body: Container());
  }
}
