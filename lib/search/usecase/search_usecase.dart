import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';

import 'package:reader/search/provider/search_provider.dart';

class SearchKeywordUsecase {
  static Future<List<BookModel>> searchBooksFromAll(WidgetRef ref,
      {required String keyword}) async {
    Log.d("searchBooksFromAll: $keyword");
    final bookSourceList = BookSourceService().bookSourceList;
    final List<BookModel> bookList = [];
    for (var bookSource in bookSourceList) {
      final books = await searchBookFromUuid(keyword, uuid: bookSource.uuid);
      ref
          .read(searchBooksProvider(keyword).notifier)
          .pushSearchGroup(bookSource, books);
    }
    return bookList;
  }

  static Future<List<BookModel>> searchBookFromUuid(String keyword,
      {required String uuid}) async {
    final res = await BookSourceService()
        .action(uuid: uuid, act: "search", args: {"key": keyword});
    return (res).map<BookModel>((r) {
      return BookModel.fromJson(r);
    }).toList();
  }
}
