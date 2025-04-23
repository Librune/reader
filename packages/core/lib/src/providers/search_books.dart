import 'package:core/core.dart';
import 'package:core/src/models/search_group.dart';
import 'package:core/src/services/book_source.dart';
import 'package:core/src/usecases/book_source/search_books.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_books.g.dart';

@riverpod
class SearchBooks extends _$SearchBooks {
  final log = Logger('search_books_provider');
  @override
  Future<List<SearchGroupModel>> build() async {
    return [];
  }

  searchByKeyword(String key) async {
    log.info("搜索关键字", key);
    state = AsyncData([]);
    BookSourceService().bookCores.forEach((uuid, value) async {
      var books = await BookSourceSearchBooksCase().call(
        BookSourceActionOptions(
          uuid: uuid,
          action: "search",
          params: {"key": key, "page": 1, "count": 10},
        ),
      );
      state = AsyncData([
        ...state.value ?? [],
        SearchGroupModel(
          name: value['metadata']['name'],
          uuid: uuid,
          books: books,
        ),
      ]);
    });
    state = AsyncData([]);
  }
}
