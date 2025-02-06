import 'package:isar/isar.dart';
import 'package:reader/app/architecture/service/path.dart';
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

  late final Isar isar;
  late ProgressModel progress;
  late final CatalogModel catalog;
  init(CatalogModel catalog) async {
    Log.e('ProgressUsecase init');
    this.catalog = catalog;
    isar = await Isar.open([ProgressModelSchema], directory: PathService().docPath, name: "progress");
    final _progress = (await isar.progressModels.where().filter().bookIdEqualTo(catalog.bookId).findFirst());
    if (_progress == null) {
      progress = ProgressModel(
          bookId: catalog.bookId,
          volumeId: catalog.volumes.first.vid,
          volumeIndex: 0,
          chapterId: catalog.flatChapterList.first.cid,
          chapterIndex: 0,
          paragraphIndex: 0,
          textLineIndex: 0);
      await _sync();
    } else {
      progress = _progress;
    }
  }

  update({required PagePainter page}) {
    progress = progress.copyWith(
        volumeId: catalog.volumes[page.volumeIndex].vid,
        volumeIndex: page.volumeIndex,
        chapterId: page.chapterId,
        chapterIndex: page.chapterIndex,
        paragraphIndex: page.painters.first.paraIndex,
        textLineIndex: page.painters.first.paraLineIndex);
    _sync();
  }

  _sync() async {
    await isar.writeTxn(() async {
      await isar.progressModels.put(progress);
    });
  }
}
