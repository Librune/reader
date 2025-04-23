import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:rc/rc.dart';

class BookSourceSearchBooksCase<T>
    implements UseCase<BookSourceActionOptions, Future<List<SearchBook>>> {
  final log = Logger('book_source_search_books');
  @override
  Future<List<SearchBook>> call(BookSourceActionOptions params) async {
    log.info("执行书源搜索操作", params);
    return BookSourceService().searchBooks(params);
  }
}
