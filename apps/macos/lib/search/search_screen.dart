import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader_macos/app/components/content_area.dart';
import 'package:reader_macos/app/utils/color.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SearchScreen extends StatefulHookConsumerWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final log = Logger('search_screen');
  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(searchBooksProvider);
    return ContentArea(
      title: "搜索",
      subtitle: "按关键字搜索书籍",
      action: Row(
        children: [
          Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: ShadInput(
              style: TextStyle(fontSize: 13),
              placeholderStyle: TextStyle(fontSize: 13),
              cursorHeight: 14,
              placeholder: Text('搜索书籍或作者'),
              cursorColor: CupertinoColors.systemGrey,
              keyboardType: TextInputType.name,
              leading: Icon(
                CupertinoIcons.search,
                size: 16,
                color: CupertinoColors.systemGrey,
              ),
              onSubmitted: (value) {
                ref.read(searchBooksProvider.notifier).searchByKeyword(value);
              },
            ),
          ),
        ],
      ),
      child: switch (groups) {
        AsyncData(:final value) => ListView.separated(
          itemBuilder: (context, index) {
            final SearchGroupModel group = value[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 26, bottom: 14),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Container(
                            width: 6,
                            height: 16,
                            margin: EdgeInsets.only(right: 6, bottom: 1),
                            decoration: BoxDecoration(
                              color: colorFromString(group.name),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: group.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: CupertinoColors.black.withValues(alpha: .8),
                          ),
                        ),
                        TextSpan(
                          text: "\n\t\n",
                          style: TextStyle(fontSize: 1, height: 3),
                        ),
                        TextSpan(
                          text: group.uuid,
                          style: TextStyle(
                            fontSize: 11,
                            color: CupertinoColors.black.withValues(alpha: .4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GridView.builder(
                  padding: EdgeInsets.only(left: 26, right: 26, bottom: 14),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 340,
                    mainAxisExtent: 106,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 24,
                  ),
                  itemCount: group.books.length,
                  itemBuilder: (context, index) {
                    final book = group.books[index];
                    return GestureDetector(
                      child: Row(
                        spacing: 12,
                        children: [
                          CachedNetworkImage(
                            httpHeaders: {
                              "user-agent":
                                  BookSourceService().bookCores[group
                                      .uuid]!['metadata']['userAgent'],
                            },
                            imageUrl: book.cover ?? "",
                            fit: BoxFit.cover,
                            width: 72,
                            height: 100,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    book.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.black.withValues(
                                        alpha: .8,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${book.author ?? "佚名"} / ${book.status?.name ?? "连载中"}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.black.withValues(
                                        alpha: .4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    book.lastUpdateTime ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.black.withValues(
                                        alpha: .4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "标签：${(book.tags ?? []).take(4).join("、")}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.black.withValues(
                                        alpha: .4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // ref
                        //     .read(
                        //       bookDetailProvider(
                        //         book.id,
                        //         uuid: group.uuid,
                        //       ).notifier,
                        //     )
                        //     .refresh();
                        context.push("/book_detail/${group.uuid}/${book.id}");
                        // showShadDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return ShadDialog(
                        //       title: const Text('Edit Profile'),
                        //       description: const Text(
                        //         "Make changes to your profile here. Click save when you're done",
                        //       ),
                        //       actions: const [
                        //         ShadButton(child: Text('Save changes')),
                        //       ],
                        //       child: Container(
                        //         width: 375,
                        //         padding: const EdgeInsets.symmetric(
                        //           vertical: 20,
                        //         ),
                        //         child: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                    );
                  },
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox.shrink();
          },
          itemCount: value.length,
        ),
        _ => const Center(child: SizedBox.shrink()),
      },
    );
  }
}
