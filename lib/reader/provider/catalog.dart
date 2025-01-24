import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog.g.dart';

@Riverpod(keepAlive: true)
class Catalog extends _$Catalog {
  @override
  Future<CatalogModel> build(BookModel book) async {
    Log.e("Catalog build");
    final json =
        await BookSourceService().action(uuid: book.bookSourceId!, act: "catalog", args: {"book_id": book.bookId});
    return CatalogModel.fromJson({"volumes": json, ...book.toJson()});
  }
}
