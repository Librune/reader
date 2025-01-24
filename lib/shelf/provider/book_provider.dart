import 'package:isar/isar.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_provider.g.dart';

@Riverpod(keepAlive: true)
class BookProvider extends _$BookProvider {
  late final Isar isar;
  @override
  Future<List<BookModel>> build() async {
    isar = await Isar.open([BookModelSchema], directory: PathService().docPath);
    return isarBookModels.where().findAll();
  }

  add(BookModel book) async {
    await isar.writeTxn(() async {
      await isar.bookModels.put(book);
    });
    state = AsyncData([...state.value!, book]);
  }

  remove(BookModel book) async {
    await isar.writeTxn(() async {
      await isar.bookModels.delete(book.id!);
    });
    state = AsyncData(state.value!.where((element) => element.id != book.id).toList());
  }

  IsarCollection<BookModel> get isarBookModels => isar.bookModels;
}
