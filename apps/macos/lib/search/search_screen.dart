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
          padding: const EdgeInsets.symmetric(horizontal: 28),
          itemBuilder: (context, index) {
            final SearchGroupModel group = value[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // 来源标题部分
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colorFromString(group.name).withOpacity(0.6),
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
                          color: CupertinoColors.black.withAlpha(90),
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
                    maxCrossAxisExtent: 380,
                    mainAxisExtent: 138, // 从145减少到138，进一步减少底部空间
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 24,
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
                        padding: const EdgeInsets.all(
                          14,
                        ).copyWith(bottom: 10), // 减少底部padding
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                httpHeaders: {
                                  "user-agent":
                                      BookSourceService().bookCores[group
                                          .uuid]!['metadata']['userAgent'],
                                },
                                imageUrl: book.cover ?? "",
                                fit: BoxFit.cover,
                                width: 72,
                                height: 108, // 调整为更合适的高度，保持约 2:3 的宽高比例
                                placeholder:
                                    (context, url) => Container(
                                      color: CupertinoColors.systemGrey6,
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: CupertinoColors.systemGrey6,
                                      child: const Icon(
                                        CupertinoIcons.book,
                                        size: 24,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  const SizedBox(height: 10), // 增加间距，从6改为10
                                  Text(
                                    "${book.author ?? "佚名"} · ${book.status?.name ?? "连载中"}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.black.withAlpha(
                                        110,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  if (book.lastUpdateTime != null)
                                    Text(
                                      book.lastUpdateTime!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.black.withAlpha(
                                          110,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 3),
                                  // 标签使用与其他信息相同的样式
                                  if (book.tags != null &&
                                      book.tags!.isNotEmpty)
                                    Text(
                                      book.tags!.take(4).join(" · "),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.black.withAlpha(
                                          110,
                                        ),
                                      ),
                                    ),
                                ],
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
                const SizedBox(height: 20),
              ],
            );
          },
          itemCount: value.length,
        ),
        _ => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 36,
                  color: CupertinoColors.systemGrey.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                const Text(
                  '输入关键词开始搜索',
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }
}
