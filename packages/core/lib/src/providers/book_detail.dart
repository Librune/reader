import 'package:core/core.dart';
import 'package:core/src/usecases/book_source/book_detail.dart';
import 'package:rc/rc.dart' as rc;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_detail.g.dart';

@riverpod
class BookDetail extends _$BookDetail {
  final log = Logger('book_detail_provider');
  @override
  Future<rc.BookDetail> build(String bid, {required String uuid}) async {
    return BookSourceBookDetailUseCase().call(
      BookSourceActionOptions(
        uuid: uuid,
        action: "book_detail",
        params: {"bid": bid},
      ),
    );
  }

  refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      var a = await BookSourceBookDetailUseCase().call(
        BookSourceActionOptions(
          uuid: uuid,
          action: "book_detail",
          params: {"bid": bid},
        ),
      );
      log.info("刷新书籍详情", a.description);
      return a;
    });
  }
}
