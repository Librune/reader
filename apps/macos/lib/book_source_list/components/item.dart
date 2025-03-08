import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookSourceItem extends StatefulHookConsumerWidget {
  const BookSourceItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceItemState();
}

class _BookSourceItemState extends ConsumerState<BookSourceItem> {
  @override
  Widget build(BuildContext context) {
    // final BookSourceModel bookSource = ref.watch(bookSourceProvider);
    return Container();
  }
}
