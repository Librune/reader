import 'dart:convert';

import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/search/data/model/search_book_item.dart';

class BookSourceActionUsecase {
  static Future<List<SearchBookItemModel>> searchBooksFromAll(String keyword) async {
    final bookSourceList = BookSourceService().bookSourceList;
    final List<SearchBookItemModel> bookList = [];
    for (var bookSource in bookSourceList) {
      final res = await searchBookFromUuid(keyword, uuid: bookSource.uuid);
      bookList.addAll(res);
    }
    return bookList;
  }

  static Future<List<SearchBookItemModel>> searchBookFromUuid(String keyword, {required String uuid}) async {
    final res = await BookSourceService().action(uuid: uuid, act: "search", args: [keyword]);
    return jsonDecode(res).map((r) {
      return SearchBookItemModel.fromJson(r);
    }).toList();
  }
}
