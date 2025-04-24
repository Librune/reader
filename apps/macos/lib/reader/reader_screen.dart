import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReaderScreen extends StatefulHookConsumerWidget {
  const ReaderScreen({
    super.key,
    required this.uuid,
    required this.bid,
    required this.cid,
  });
  final String uuid;
  final String bid;
  final String cid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _readerProvider = readerProvider(
      uuid: widget.uuid,
      bid: widget.bid,
      cid: widget.cid,
    );
    final reader = ref.watch(_readerProvider);
    return Container(
      color: CupertinoColors.white,
      child: switch (reader) {
        AsyncData(:final value) => Container(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: CupertinoColors.black),
          ),
        ),
        AsyncLoading() => const CupertinoActivityIndicator(),
        AsyncError() => const Center(
          child: Text(
            '加载失败',
            style: TextStyle(color: CupertinoColors.destructiveRed),
          ),
        ),
        _ => SizedBox.shrink(),
      },
    );
  }
}
