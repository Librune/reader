import 'package:flutter/material.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/provider/catalog.dart';
import 'package:reader/reader/provider/config.dart';
import 'package:reader/reader/provider/reader.dart';

class ProviderUsecase {
  static ProviderUsecase? _instance;
  // final BookModel book;
  // final BuildContext context;

  ProviderUsecase._internal();

  factory ProviderUsecase() {
    return _instance ??= ProviderUsecase._internal();
  }

  late CatalogProvider catalog;
  late ReaderProvider reader;
  late ReaderConfigProvider config;

  void init({
    required BookModel book,
    required BuildContext context,
  }) {
    catalog = catalogProvider(book);
    reader = readerProvider(book, context: context);
    config = readerConfigProvider(context);
  }

  void dispose() {}
}
