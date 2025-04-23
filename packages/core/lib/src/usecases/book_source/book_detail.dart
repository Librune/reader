import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:rc/rc.dart';

class BookSourceBookDetailUseCase<T>
    implements UseCase<BookSourceActionOptions, Future<BookDetail>> {
  final log = Logger('book_source_book_detail');
  @override
  Future<BookDetail> call(BookSourceActionOptions params) async {
    log.info("获取书籍详情", params);
    return BookSourceService().bookDetail(params);
  }
}
