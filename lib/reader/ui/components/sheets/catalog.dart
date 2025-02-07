import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/usecase/progress_usecase.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

class CatalogSheetContent extends StatefulHookConsumerWidget {
  const CatalogSheetContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CatalogSheetContentState();
}

typedef CatalogContentState = _CatalogSheetContentState;

class _CatalogSheetContentState extends ConsumerState<CatalogSheetContent> {
  void onShow() {
    Log.e("onShow");
  }

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController(keepScrollOffset: true);
    final colorScheme = Theme.of(context).colorScheme;
    final catalog = ref.watch(ProviderUsecase().catalog).value;
    final cid = ref.watch(cidProvider);
    // final volumeList = ref.watch(ProviderUsecase().catalog).value?.volumes ?? [];
    // final flatChapterList = ref.watch(ProviderUsecase().catalog).value?.flatChapterList ?? [];
    // final flatList = <ChapterModel>[];
    // for (final volume in volumeList) {
    //   final volumeHeader = ChapterModel(cid: "", title: volume.title);
    //   flatList.add(volumeHeader);
    //   final volumeChapterNum = volume.chapters.length;
    //   final chapters = flatChapterList.sublist(_index, _index + volumeChapterNum);
    //   flatList.addAll(chapters);
    //   _index += volumeChapterNum;
    // }
    final flatList = useMemoized(() {
      if (catalog == null) return [];
      final volumeList = catalog.volumes;
      final flatChapterList = catalog.flatChapterList;
      int _index = 0;
      final list = <ChapterModel>[];
      for (final volume in volumeList) {
        final volumeHeader = ChapterModel(cid: "", title: volume.title);
        list.add(volumeHeader);
        final volumeChapterNum = volume.chapters.length;
        final chapters = flatChapterList.sublist(_index, _index + volumeChapterNum);
        list.addAll(chapters);
        _index += volumeChapterNum;
      }
      return list;
    }, [catalog]);
    useEffect(() {
      final index = flatList.indexWhere((element) => element.cid == cid);
      if (index != -1) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          controller.jumpTo(index * 64.0);
        });
      }
      return null;
    }, [flatList, cid]);
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverList.separated(
          itemBuilder: (context, index) {
            final chapter = flatList[index];
            final isCurrent = chapter.cid == cid;
            return chapter.cid != ""
                ? ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    title: Text(
                      chapter.title,
                      style: TextStyle(
                          color: isCurrent ? colorScheme.primary : colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal),
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
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      chapter.title,
                      style: TextStyle(color: colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
          },
          separatorBuilder: (context, index) {
            return Divider(
              indent: 20,
              endIndent: 20,
              height: 1,
              thickness: .6,
            );
          },
          itemCount: flatList.length,
        )
      ],
    );
  }
}

// class CatalogSheetContent extends StatelessWidget {
//   const CatalogSheetContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const _CatalogContent();
//   }
// }


// class _CatalogContent extends StatefulHookConsumerWidget {
//   const _CatalogContent();

//   @override
//   ConsumerState<_CatalogContent> createState() => _CatalogContentState();
// }

// class _CatalogContentState extends ConsumerState<_CatalogContent>
// //  with AutomaticKeepAliveClientMixin
// {
//   // @override
//   // bool get wantKeepAlive => true;

//   void onShow() {
//     Log.e("onShow");
//   }

//   @override
//   Widget build(BuildContext context) {
//     // super.build(context);
   
//   }
// }
