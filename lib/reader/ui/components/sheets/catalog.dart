import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class CatalogSheetContent extends StatelessWidget {
  const CatalogSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CatalogContent();
  }
}

class _CatalogContent extends StatefulHookConsumerWidget {
  const _CatalogContent();

  @override
  ConsumerState<_CatalogContent> createState() => _CatalogContentState();
}

class _CatalogContentState extends ConsumerState<_CatalogContent> with AutomaticKeepAliveClientMixin {
  Widget? _cachedContent;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _cachedContent ??= _buildContent(context);
    return _cachedContent!;
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final volumes = ref.watch(ProviderUsecase().catalog).value?.volumes ?? [];
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          // delay: const Duration(milliseconds: 250),
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
