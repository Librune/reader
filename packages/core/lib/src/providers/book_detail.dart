import 'package:core/core.dart';
import 'package:core/src/usecases/book_source/book_detail.dart';
import 'package:rc/rc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_detail.g.dart';

@riverpod
class BookDetail extends _$BookDetail {
  final log = Logger('book_detail_provider');
  @override
  Future<BookDetail> build(String bid, {required String uuid}) async {
    return BookSourceBookDetailUseCase().call(
      BookSourceActionOptions(
        uuid: uuid,
        action: "book_detail",
        params: {"bid": bid},
      ),
    );
  }
}
