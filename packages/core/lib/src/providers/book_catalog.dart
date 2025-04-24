import 'package:core/core.dart';
import 'package:core/src/usecases/book_source/book_catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_catalog.g.dart';

@riverpod
class BookCatalog extends _$BookCatalog {
  final log = Logger('book_catalog_provider');
  @override
  Future<List<CatalogVolume>> build(String id, {required String uuid}) async {
    return BookCatalogUseCase().call(
      BookSourceActionOptions(
        uuid: uuid,
        action: "book_catalog",
        params: {"id": id},
      ),
    );
  }
}
