import 'dart:io';

import 'package:core/src/models/book_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_source.g.dart';

@Riverpod(keepAlive: true)
class BookSource extends _$BookSource {
  @override
  List<BookSourceModel> build() {
    // listenSelf(onSelfChange);
    // return BookSourceService().bookSourceList;
    return [];
  }

  // Future<BookSourceModel> addFromFile(File file) async {}
}
