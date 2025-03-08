import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BooksourceEditorScreen extends StatefulHookConsumerWidget {
  const BooksourceEditorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BooksourceEditorScreenState();
}

class _BooksourceEditorScreenState extends ConsumerState<BooksourceEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: CupertinoColors.white));
  }
}
