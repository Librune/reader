import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/app/components/book_cover.dart';
import 'package:reader_macos/app/components/content_area.dart';
import 'package:reader_macos/app/extensions/book_detail.dart';

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
      canPop: true,
      subtitle: "core-uuid:${widget.uuid}\t\tbook-id: ${widget.id}",
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
              Row(
                spacing: 16,
                children: [
                  BookCover(
                    widget.id,
                    uuid: widget.uuid,
                    width: 90,
                    height: 128,
                    coverUrl: value.cover,
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              value.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.black,
                              ),
                            ),
                          ),
                          ...value.infoLines.map(
                            (line) => Text(
                              line,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.7,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6.withOpacity(.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CupertinoColors.systemGrey5,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    value.description ?? "暂无简介",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          _ => SizedBox.shrink(),
        },
      ),
    );
  }
}
