import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/delayed_sliver_list.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class CatalogSheetContent extends StatefulHookConsumerWidget {
  const CatalogSheetContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CatalogSheetContentState();
}

class _CatalogSheetContentState extends ConsumerState<CatalogSheetContent> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final volumes = ref.watch(ProviderUsecase().catalog).value?.volumes ?? [];
    return CustomScrollView(
      slivers: [
        DelayedSliverList(
          delay: const Duration(milliseconds: 250),
          itemBuilder: (context, index) {
            final volume = volumes[index];
            return Column(
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
                          onTap: () {
                            // ref.read(ReaderProvider(book, context: context).notifier).jumpToChapter(chapter);
                            // widget.onChapterTap(chapter);
                            ref.read(ProviderUsecase().reader.notifier).jumpToChapter(chapter);
                          },
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
            );
          },
          itemCount: volumes.length,
        )
      ],
    );
  }
}
