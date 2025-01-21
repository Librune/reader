import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/book_source/usecase/bks_runtime_usecase.dart';

class BookSourceTestScreen extends HookConsumerWidget {
  const BookSourceTestScreen({super.key, required this.uuid});
  final String uuid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = useFuture(useMemoized<dynamic>(() async {
      try {
        final res = await BookSourceService().action(uuid: uuid, act: "test");
        return jsonDecode(res);
      } catch (e) {
        Log.e(e);
        return null;
      }
    }));
    return Scaffold(
        appBar: AppTopBar(title: "测试书源"),
        body: SingleChildScrollView(
          child: Text(data.data?.toString() ?? ""),
        ));
  }
}
