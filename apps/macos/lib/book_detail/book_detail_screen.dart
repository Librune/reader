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
    final bookCatalog = ref.watch(
      bookCatalogProvider(widget.id, uuid: widget.uuid),
    );
    return ContentArea(
      title: "图书详情",
      canPop: true,
      subtitle: "core-uuid:${widget.uuid}\t\tbook-id: ${widget.id}",
      action: Row(spacing: 10, children: [Spacer()]),
      child: switch (bookDetail) {
        AsyncLoading() => Center(child: CupertinoActivityIndicator(radius: 10)),
        AsyncError(:final error, :final stackTrace) => Text(error.toString()),
        AsyncData(:final value) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 18, right: 24, bottom: 12, top: 0),
            child: Column(
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
                switch (bookCatalog) {
                  AsyncLoading() => Center(
                    child: CupertinoActivityIndicator(radius: 10),
                  ),
                  AsyncError(:final error, :final stackTrace) => Text(
                    error.toString(),
                  ),
                  AsyncData(:final value) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 16),
                        child: Row(
                          children: [
                            Text(
                              "目录",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${value.fold(0, (int sum, item) => sum + item.chapters.length)}章",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...value.map(
                        (volume) => Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: CupertinoColors.systemGrey6,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemBackground,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CupertinoColors.systemGrey6,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  volume.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 320,
                                        mainAxisExtent: 36,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 16,
                                      ),
                                  itemCount: volume.chapters.length,
                                  itemBuilder: (context, index) {
                                    final chapter = volume.chapters[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey6
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: CupertinoColors.systemGrey5,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              chapter.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: CupertinoColors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: CupertinoColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              // 假设这里有章节字数或其他信息
                                              "${index + 1}",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    CupertinoColors.systemGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _ => SizedBox.shrink(),
                },
              ],
            ),
          ),
        ),
        _ => SizedBox.shrink(),
      },
    );
  }
}
