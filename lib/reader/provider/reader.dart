import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/provider/catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reader.g.dart';

@riverpod
class Reader extends _$Reader {
  @override
  Future<List<dynamic>> build(BookModel book) async {
    final catalog = await ref.read(catalogProvider(book).future);
    return [];
  }
}
