import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reader.g.dart';

@riverpod
class Reader extends _$Reader {
  final log = Logger('reader_provider');
  @override
  Future<String> build({
    required String uuid,
    required String bid,
    required String cid,
  }) async {
    final res = await BookChapterUseCase().call(
      BookSourceActionOptions(
        uuid: uuid,
        action: "book_chapter",
        params: {"bid": bid, "cid": cid},
      ),
    );
    return res.content;
  }
}
