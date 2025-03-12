import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_books.g.dart';

@riverpod
class SearchBooks extends _$SearchBooks {
  @override
  Future<List<dynamic>> build() async {
    return [];
  }

  searchByKeyword(String key) async {
    state = AsyncData([]);
  }
}
