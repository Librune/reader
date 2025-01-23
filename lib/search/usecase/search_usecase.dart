import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/search/data/model/search_book_item.dart';
import 'package:reader/search/provider/search_provider.dart';

class SearchKeywordUsecase {
  static Future<List<SearchBookItemModel>> searchBooksFromAll(WidgetRef ref, {required String keyword}) async {
    Log.d("searchBooksFromAll: $keyword");
    final bookSourceList = BookSourceService().bookSourceList;
    final List<SearchBookItemModel> bookList = [];
    for (var bookSource in bookSourceList) {
      final books = await searchBookFromUuid(keyword, uuid: bookSource.uuid);
      ref.read(searchBooksProvider(keyword).notifier).pushSearchGroup(bookSource, books);
    }
    return bookList;
  }

  static Future<List<SearchBookItemModel>> searchBookFromUuid(String keyword, {required String uuid}) async {
    final res = await BookSourceService().action(uuid: uuid, act: "search", args: [keyword]);
    final jsonList = Platform.isAndroid ? jsonDecode(res) : jsonDecode(jsonDecode(res));
    return (jsonList).map<SearchBookItemModel>((r) {
      return SearchBookItemModel.fromJson(r);
    }).toList();
  }
}
