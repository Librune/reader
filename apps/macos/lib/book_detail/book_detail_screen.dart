import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/app/components/content_area.dart';

class BookDetailScreen extends StatefulHookConsumerWidget {
  const BookDetailScreen({super.key, required this.uuid, required this.id});

  final String uuid;
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  final log = Logger('book_detail_screen');
  @override
  Widget build(BuildContext context) {
    final bookDetail = ref.watch(
      bookDetailProvider(widget.id, uuid: widget.uuid),
    );
    return ContentArea(
      title: "图书详情",
      padding: EdgeInsets.only(top: 20),
      action: Row(spacing: 10, children: [Spacer()]),
      child: Container(
        margin: EdgeInsets.only(left: 18, right: 24, bottom: 12, top: 0),
        child: switch (bookDetail) {
          AsyncLoading() => Center(
            child: CupertinoActivityIndicator(radius: 10),
          ),
          AsyncError(:final error, :final stackTrace) => Text(error.toString()),
          AsyncData(:final value) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value.name),
              Text(value.author ?? "无名氏"),
              Text(value.description ?? "暂无简介"),
            ],
          ),
          _ => SizedBox.shrink(),
        },
      ),
    );
  }
}
