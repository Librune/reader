import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/data/model/progress.dart';
import 'package:reader/reader/ui/components/render.dart';

class ProgressUsecase {
  static ProgressUsecase? _instance;
  // final BookModel book;
  ProgressUsecase._internal();
  factory ProgressUsecase() {
    return _instance ??= ProgressUsecase._internal();
  }
  final Isar isar = Isar.getInstance()!;
  late ProgressModel progress;
  late CatalogModel catalog;
  init(CatalogModel catalog) async {
    Log.e('ProgressUsecase init');
    this.catalog = catalog;
    final _progress = (await isar.progressModels.where().filter().bookIdEqualTo(catalog.bookId).findFirst());
    if (_progress == null) {
      progress = ProgressModel(
          bookId: catalog.bookId,
          volumeId: catalog.volumes.first.vid,
          volumeIndex: 0,
          chapterId: catalog.flatChapterList.first.cid,
          chapterIndex: 0,
          flatIndex: 0,
          paragraphIndex: 0,
          textLineIndex: 0);
      await _sync();
    } else {
      progress = _progress;
    }
  }

  detectPage(List<PagePainter> pagePainters) {
    if (progress.paragraphIndex <= 0) {
      return 0;
    }
    for (var page in pagePainters) {
      for (var painter in page.painters) {
        if (painter.paraIndex == progress.paragraphIndex && progress.textLineIndex == painter.paraLineIndex) {
          return page.pageIndex;
        }
      }
    }
  }

  update({required PagePainter page}) {
    progress = progress.copyWith(
        volumeId: catalog.volumes[page.volumeIndex].vid,
        volumeIndex: page.volumeIndex,
        chapterId: page.chapterId,
        chapterIndex: page.chapterIndex,
        paragraphIndex: page.painters.first.paraIndex,
        flatIndex: page.flatIndex,
        // TODO 改成 chapterIndex 为相对卷的索引
        // TODO 添加 flatIndex 作为章节在整本书中的索引
        textLineIndex: page.painters.first.paraLineIndex);
    _sync();
  }

  jumpChapter({required ChapterModel chapter}) {
    progress = progress.copyWith(
        chapterId: chapter.cid,
        chapterIndex: catalog.flatChapterList.indexWhere((element) => element.cid == chapter.cid),
        paragraphIndex: 0,
        textLineIndex: 0);
    _sync();
  }

  _sync() async {
    await isar.writeTxn(() async {
      await isar.progressModels.put(progress);
    });
  }
}

class CidNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String cid) {
    state = cid;
  }
}

final cidProvider = NotifierProvider<CidNotifier, String>(CidNotifier.new);
