import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/book_source_list/components/status.dart';

class BookSourceItem extends StatefulHookConsumerWidget {
  const BookSourceItem({super.key, this.checked = false, required this.model});
  final bool checked;
  final BookSourceModel model;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceItemState();
}

class _BookSourceItemState extends ConsumerState<BookSourceItem> {
  @override
  Widget build(BuildContext context) {
    // final BookSourceModel bookSource = ref.watch(bookSourceProvider);
    return Container(
      decoration: BoxDecoration(
        color: widget.checked ? CupertinoColors.systemGrey.withValues(alpha: .1) : null,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.model.name, style: TextStyle(fontSize: 14)),
          BookSourceStatus(enabled: widget.model.enabled),
        ],
      ),
    );
  }
}
