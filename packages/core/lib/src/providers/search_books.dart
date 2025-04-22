import 'package:core/core.dart';
import 'package:core/src/providers/providers.dart';
import 'package:core/src/services/book_source.dart';
import 'package:core/src/usecases/book_source/exec_action_all.dart';
import 'package:core/src/usecases/book_source/search_books.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';

part 'search_books.g.dart';

@riverpod
class SearchBooks extends _$SearchBooks {
  final log = Logger('search_books_provider');
  @override
  Future<List<dynamic>> build() async {
    return [];
  }

  searchByKeyword(String key) async {
    log.info("搜索关键字", key);
    final enabledBookSourceUuids =
        ref
            .read(bookSourceProvider)
            .value
            ?.where((element) => element.enabled)
            .map((e) => e.uuid!)
            .toList() ??
        [];
    // final res = await BookSourceExecActionAllUseCase().call(
    //   BookSourceExecActionAllOptions(
    //     uuids: enabledBookSourceUuids,
    //     action: "search",
    //     params: {"key": key, "page": 1, "count": 5},
    //   ),
    // );
    // log.debug("搜索结果", res);
    BookSourceService().bookCores.forEach((uuid, value) {
      BookSourceSearchBooksCase().call(
        BookSourceActionOptions(
          uuid: uuid,
          action: "search",
          params: {"keyword": key, "page": 1, "count": 10},
        ),
      );
    });
    state = AsyncData([]);
  }
}
