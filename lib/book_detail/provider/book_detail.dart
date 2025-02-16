import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/shelf/provider/book_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_detail.g.dart';

@riverpod
Future<bool> bookInShelf(Ref ref, BookModel book) async {
  return (await ref.watch(bookProviderProvider.future)).any((element) =>
      element.bookSourceId == book.bookSourceId &&
      element.bookId == book.bookId);
}
