import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';

class BookChapterUseCase
    implements UseCase<BookSourceActionOptions, Future<Chapter>> {
  final log = Logger('book_chapter');
  @override
  Future<Chapter> call(BookSourceActionOptions params) async {
    log.info("获取章节信息", params);
    return BookSourceService().bookChapter(params);
  }
}
