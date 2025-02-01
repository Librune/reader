import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog.g.dart';

@Riverpod(keepAlive: true)
class Catalog extends _$Catalog {
  @override
  Future<CatalogModel> build(BookModel book) async {
    Log.e("Catalog build");
    listenSelf(_onSelfChange);
    try {
      if (catalogJsonFile.existsSync()) {
        final json = jsonDecode(await catalogJsonFile.readAsString());
        return CatalogModel.fromJson(json);
      } else {
        throw Exception("catalog.json not exist");
      }
    } catch (e) {
      Log.e("Catalog File read error: $e");
      final json =
          await BookSourceService().action(uuid: book.bookSourceId!, act: "catalog", args: {"book_id": book.bookId});
      return CatalogModel.fromJson({"volumes": json, ...book.toJson()});
    }
  }

  _onSelfChange(AsyncValue<CatalogModel>? oldValue, AsyncValue<CatalogModel> newValue) {
    if (newValue.value != null && oldValue?.value != null) {
      Log.e("Catalog _onSelfChange");
      final CatalogModel? catalog = newValue.value;
      if (catalog == null) return;
      catalogJsonFile.writeAsStringSync(jsonEncode(catalog.toJson()));
    }
  }

  File get catalogJsonFile => File(join(PathService().getBookCacheDir(book).path, "catalog.json"));
}
