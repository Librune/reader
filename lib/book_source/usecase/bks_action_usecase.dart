import 'dart:convert';

import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';

class BookSourceActionUsecase {
  static Future<List<BookModel>> searchBooksFromAll(String keyword) async {
    Log.d("searchBooksFromAll: $keyword");
    final bookSourceList = BookSourceService().bookSourceList;
    final List<BookModel> bookList = [];
    for (var bookSource in bookSourceList) {
      bookList.addAll(await searchBookFromUuid(keyword, uuid: bookSource.uuid));
    }
    return bookList;
  }

  static Future<List<BookModel>> searchBookFromUuid(String keyword, {required String uuid}) async {
    final res = await BookSourceService().action(uuid: uuid, act: "search", args: [keyword]);
    return jsonDecode(res).map<BookModel>((r) {
      return BookModel.fromJson(r);
    }).toList();
  }
}
