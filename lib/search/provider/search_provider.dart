import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/search/data/model/search_book_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
class SearchBooks extends _$SearchBooks {
  @override
  List<Map<String, dynamic>> build(String keyword) {
    return [];
  }

  pushSearchGroup(BookSourceModel bookSource, List<SearchBookItemModel> bookList) {
    state = [
      ...state,
      <String, dynamic>{"bks": bookSource, "books": bookList}
    ];
  }

  // _refreshSearch(String keyword) async {
  //   final bksList = await ref.read(bookSourceProvider.future);
  //   final List<SearchBookItemModel> bookList = [];
  //   for (var bks in bksList) {
  //     final res = await BookSourceRuntimeUseCase(uuid: bks.uuid).action("search", args: [keyword]);
  //     final json = jsonDecode(res);
  //     final List<SearchBookItemModel> list = (json as List).map((e) => SearchBookItemModel.fromJson(e)).toList();
  //     bookList.addAll(list);
  //   }
  //   state = AsyncData(bookList);
  // }
}
