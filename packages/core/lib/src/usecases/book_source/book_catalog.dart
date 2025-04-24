import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';

class BookCatalogUseCase
    implements UseCase<BookSourceActionOptions, Future<List<CatalogVolume>>> {
  final log = Logger('book_catalog');
  @override
  Future<List<CatalogVolume>> call(BookSourceActionOptions params) async {
    log.info("获取书籍目录", params);
    return BookSourceService().bookCatalog(params);
  }
}
