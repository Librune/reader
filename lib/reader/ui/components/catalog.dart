import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/discover/ui/components/fake_search_bar.dart';
import 'package:reader/reader/provider/catalog.dart';

class CatalogSheet extends HookConsumerWidget {
  const CatalogSheet({super.key, required this.book});
  final BookModel book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider(book)).asData!.value;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.only(top: 48, left: 4, right: 20, bottom: 12),
        //   child: Row(
        //     children: [Expanded(child: FakeSearchBar()), Text("↓去当前")],
        //   ),
        // ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              for (var volume in catalog.volumes)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                        child: Text(volume.title,
                            style: TextStyle(color: colorScheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      ...volume.chapters.map((chapter) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                title: Text(
                                  chapter.title,
                                  style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  chapter.updateTime ?? "",
                                  style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {},
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                                height: 1,
                                thickness: .6,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
