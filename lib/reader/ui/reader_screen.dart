import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';

class ReaderScreen extends HookConsumerWidget {
  const ReaderScreen({super.key, required this.book});
  final BookModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material();
  }
}
