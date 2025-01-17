import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';

class BookSourcePreference extends HookConsumerWidget {
  const BookSourcePreference({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: "刺猬猫阅读"),
      body: Text("编辑"),
    );
  }
}
