import 'dart:convert';

import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/book_source/provider/book_source_provider.dart';
import 'package:reader/book_source/usecase/bks_runtime_usecase.dart';
import 'package:reader/search/data/model/search_book_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
class Search extends _$Search {
  final _log = Log("Search");
  @override
  Future<List<SearchBookItemModel>> build(String keyword) async {
    final bksList = await ref.read(bookSourceProvider.future);
    final List<SearchBookItemModel> bookList = [];
    for (var bks in bksList) {
      final res = await BookSourceRuntimeUseCase(uuid: bks.uuid).action("search", args: [keyword]);
      final json = jsonDecode(res);
      final List<SearchBookItemModel> list = (json as List).map((e) => SearchBookItemModel.fromJson(e)).toList();
      bookList.addAll(list);
    }
    return bookList;
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
