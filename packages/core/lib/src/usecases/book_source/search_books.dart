import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/services/book_source.dart';

class BookSourceSearchBooksCase<T>
    implements UseCase<BookSourceActionOptions, Future<T>> {
  final log = Logger('book_source_search_books');
  @override
  Future<T> call(BookSourceActionOptions params) async {
    log.info("执行书源搜索操作", params);
    return BookSourceService().searchBooks(params);
  }
}
