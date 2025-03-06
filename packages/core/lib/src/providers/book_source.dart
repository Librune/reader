import 'package:core/src/models/book_source.dart';
import 'package:core/src/usecases/book_source/add_from_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_source.g.dart';

@Riverpod(keepAlive: true)
class BookSource extends _$BookSource {
  @override
  Future<List<BookSourceModel>> build() async {
    return [];
  }

  addFromFile() async {
    state = AsyncLoading();
    final res = await BookSourceAddFromFileUseCase().call();
    if (res != null) {
      state = AsyncData([]);
    }
  }
}
