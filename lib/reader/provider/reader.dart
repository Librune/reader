import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/provider/catalog.dart';
import 'package:reader/reader/ui/components/render.dart';
import 'package:reader/reader/usecase/text_render_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reader.g.dart';

@riverpod
class Reader extends _$Reader {
  late double screenWidth;
  late double screenHeight;

  late CatalogModel catalog;

  @override
  Future<List<PagePainter>> build(
    BookModel book, {
    required BuildContext context,
  }) async {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    catalog = await ref.read(catalogProvider(book).future);
    // ignore: use_build_context_synchronously
    TextRenderUsecase(context).init(ref, book: book);
    return [];
  }
}
