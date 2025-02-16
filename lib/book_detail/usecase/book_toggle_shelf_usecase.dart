import 'package:dartx/dartx_io.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/shelf/provider/book_provider.dart';

bookToggleShelfUsecase(WidgetRef ref, BookModel book) {
  final BookModel? _book = ref
      .read(bookProviderProvider)
      .value!
      .filter((element) =>
          element.bookSourceId == book.bookSourceId &&
          element.bookId == book.bookId)
      .firstOrNull;
  if (_book != null) {
    ref.read(bookProviderProvider.notifier).remove(_book);
  } else {
    ref.read(bookProviderProvider.notifier).add(book);
  }
}
