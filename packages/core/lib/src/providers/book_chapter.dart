import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_chapter.g.dart';

@riverpod
class BookChapter extends _$BookChapter {
  final log = Logger('book_chapter_provider');
  @override
  Future<Chapter> build({
    required String uuid,
    required String bid,
    required String cid,
  }) async {
    return BookSourceService().bookChapter(
      BookSourceActionOptions(
        uuid: uuid,
        action: "book_chapter",
        params: {"bid": bid, "cid": cid},
      ),
    );
  }
}
