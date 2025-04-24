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
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: ShadInput(
              style: const TextStyle(fontSize: 13),
              placeholderStyle: const TextStyle(fontSize: 13),
              cursorHeight: 14,
              placeholder: const Text('搜索书籍或作者'),
              cursorColor: CupertinoColors.systemGrey,
              keyboardType: TextInputType.name,
              // variant: ShadInputVariant.outline,
              leading: const Icon(
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
        AsyncData(:final value) => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            final SearchGroupModel group = value[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // 来源标题部分
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colorFromString(group.name).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        group.uuid,
                        style: TextStyle(
                          fontSize: 11,
                          color: CupertinoColors.black.withAlpha(100),
                        ),
                      ),
                    ],
                  ),
                ),
                // 书籍列表
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisExtent: 120,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: group.books.length,
                  itemBuilder: (context, index) {
                    final book = group.books[index];
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: CupertinoColors.systemGrey6,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          spacing: 14,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                httpHeaders: {
                                  "user-agent":
                                      BookSourceService().bookCores[group
                                          .uuid]!['metadata']['userAgent'],
                                },
                                imageUrl: book.cover ?? "",
                                fit: BoxFit.cover,
                                width: 66,
                                height: 96,
                                placeholder:
                                    (context, url) => Container(
                                      color: CupertinoColors.systemGrey6,
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: CupertinoColors.systemGrey6,
                                      child: const Icon(
                                        CupertinoIcons.book,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 96,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      book.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${book.author ?? "佚名"} · ${book.status?.name ?? "连载中"}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.black.withAlpha(
                                          120,
                                        ),
                                      ),
                                    ),
                                    if (book.lastUpdateTime != null)
                                      Text(
                                        book.lastUpdateTime!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: CupertinoColors.black
                                              .withAlpha(120),
                                        ),
                                      ),
                                    if (book.tags != null &&
                                        book.tags!.isNotEmpty)
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              (book.tags ?? [])
                                                  .take(4)
                                                  .join(" · "),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: CupertinoColors
                                                    .systemBlue
                                                    .withAlpha(180),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        context.push("/book_detail/${group.uuid}/${book.id}");
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          },
          itemCount: value.length,
        ),
        _ => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Text(
              '输入关键词开始搜索',
              style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            ),
          ),
        ),
      },
    );
  }
}
